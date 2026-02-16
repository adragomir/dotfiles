import * as net from "node:net";
import type { AgentMessage, ThinkingLevel } from "@mariozechner/pi-agent-core";
import type {
	AgentEndEvent,
	AgentStartEvent,
	ContextEvent,
	ExtensionAPI,
	ExtensionCommandContext,
	ExtensionContext,
	MessageEndEvent,
	MessageStartEvent,
	MessageUpdateEvent,
	ModelSelectEvent, 
	SessionCompactEvent,
	SessionForkEvent,
	SessionMessageEntry,
	SessionShutdownEvent,
	SessionStartEvent,
	SessionSwitchEvent,
	ToolCallEvent,
	ToolExecutionEndEvent,
	ToolExecutionStartEvent,
	ToolExecutionUpdateEvent,
	ToolResultEvent,
	TurnEndEvent,
	TurnStartEvent,
	UserBashEvent,
	RpcCommand,
	RpcExtensionUIRequest,
	RpcResponse,
	RpcSessionState,
} from "@mariozechner/pi-coding-agent";

const DEFAULT_PORT = 9999;

export default function (pi: ExtensionAPI) {
	pi.registerFlag("rpc-port", {
		description: "Port for remote RPC server",
		type: "string",
		default: String(DEFAULT_PORT),
	});

	let server: net.Server | null = null;
	let activeSocket: net.Socket | null = null;
	let currentCtx: ExtensionContext | null = null;
	let commandCtx: ExtensionCommandContext | null = null;
	let lineBuffer = "";

	const send = (socket: net.Socket, obj: RpcResponse | RpcExtensionUIRequest | object) => {
		try {
			socket.write(`${JSON.stringify(obj)}\n`);
		} catch {
			// Socket may be closed
		}
	};

	const broadcast = (obj: object) => {
		if (activeSocket) send(activeSocket, obj);
	};

	const success = <T extends RpcCommand["type"]>(
		id: string | undefined,
		command: T,
		data?: object | null,
	): RpcResponse => {
		if (data === undefined) {
			return { id, type: "response", command, success: true } as RpcResponse;
		}
		return { id, type: "response", command, success: true, data } as RpcResponse;
	};

	const error = (id: string | undefined, command: string, message: string): RpcResponse => {
		return { id, type: "response", command, success: false, error: message };
	};

	const unsupported = (id: string | undefined, command: string): RpcResponse => {
		return error(id, command, `Command '${command}' is not supported via remote-rpc extension`);
	};

	const extractMessages = (ctx: ExtensionContext): AgentMessage[] => {
		const messages: AgentMessage[] = [];
		for (const entry of ctx.sessionManager.getBranch()) {
			if (entry.type === "message") {
				messages.push((entry as SessionMessageEntry).message);
			}
		}
		return messages;
	};

	const buildState = (ctx: ExtensionContext): RpcSessionState => {
		const messages = extractMessages(ctx);
		return {
			model: ctx.model,
			thinkingLevel: pi.getThinkingLevel(),
			isStreaming: !ctx.isIdle(),
			isCompacting: false,
			steeringMode: "all",
			followUpMode: "all",
			sessionFile: ctx.sessionManager.getSessionFile() ?? undefined,
			sessionId: ctx.sessionManager.getSessionId(),
			sessionName: ctx.sessionManager.getSessionName() ?? undefined,
			autoCompactionEnabled: true,
			messageCount: messages.length,
			pendingMessageCount: 0,
		};
	};

	const handleCommand = async (command: RpcCommand, ctx: ExtensionContext): Promise<RpcResponse> => {
		const id = command.id;

		switch (command.type) {
			case "prompt": {
				pi.sendUserMessage(command.message);
				return success(id, "prompt");
			}

			case "steer": {
				pi.sendUserMessage(command.message, { deliverAs: "steer" });
				return success(id, "steer");
			}

			case "follow_up": {
				pi.sendUserMessage(command.message, { deliverAs: "followUp" });
				return success(id, "follow_up");
			}

			case "abort": {
				ctx.abort();
				return success(id, "abort");
			}

			case "new_session": {
				if (!commandCtx) {
					return error(id, "new_session", "Command context not available");
				}
				const result = await commandCtx.newSession(
					command.parentSession ? { parentSession: command.parentSession } : undefined,
				);
				return success(id, "new_session", { cancelled: result.cancelled });
			}

			case "get_state": {
				return success(id, "get_state", buildState(ctx));
			}

			case "set_thinking_level": {
				pi.setThinkingLevel(command.level as ThinkingLevel);
				return success(id, "set_thinking_level");
			}

			case "compact": {
				ctx.compact({ customInstructions: command.customInstructions });
				return success(id, "compact", { summarized: true });
			}

			case "get_messages": {
				return success(id, "get_messages", { messages: extractMessages(ctx) });
			}

			case "fork": {
				if (!commandCtx) {
					return error(id, "fork", "Command context not available");
				}
				const result = await commandCtx.fork(command.entryId);
				return success(id, "fork", { text: "", cancelled: result.cancelled });
			}

			case "set_session_name": {
				const name = command.name.trim();
				if (!name) {
					return error(id, "set_session_name", "Session name cannot be empty");
				}
				pi.setSessionName(name);
				return success(id, "set_session_name");
			}

			case "cycle_model":
			case "cycle_thinking_level":
			case "set_steering_mode":
			case "set_follow_up_mode":
			case "set_auto_compaction":
			case "set_auto_retry":
			case "abort_retry":
			case "bash":
			case "abort_bash":
			case "get_session_stats":
			case "export_html":
			case "switch_session":
			case "get_fork_messages":
			case "get_last_assistant_text":
			case "get_commands":
				return unsupported(id, command.type);

			default: {
				const unknownCommand = command as { type: string };
				return error(id, unknownCommand.type, `Unknown command: ${unknownCommand.type}`);
			}
		}
	};

	const handleLine = async (line: string) => {
		if (!currentCtx) return;

		try {
			const parsed = JSON.parse(line);
			const command = parsed as RpcCommand;
			const response = await handleCommand(command, currentCtx);
			if (activeSocket) send(activeSocket, response);
		} catch (e: any) {
			if (activeSocket) send(activeSocket, error(undefined, "parse", `Failed to parse command: ${e.message}`));
		}
	};

	const handleData = (data: Buffer) => {
		lineBuffer += data.toString();
		const lines = lineBuffer.split("\n");
		lineBuffer = lines.pop() ?? "";
		for (const line of lines) {
			if (line.trim()) {
				handleLine(line);
			}
		}
	};

	pi.on("session_start", async (_event: SessionStartEvent, ctx: ExtensionContext) => {
		currentCtx = ctx;

		const portStr = pi.getFlag("rpc-port") as string;
		const port = parseInt(portStr, 10) || DEFAULT_PORT;

		server = net.createServer((socket) => {
			if (activeSocket) {
				activeSocket.destroy();
			}
			activeSocket = socket;
			lineBuffer = "";

			socket.on("data", handleData);
			socket.on("close", () => {
				if (activeSocket === socket) {
					activeSocket = null;
				}
			});
			socket.on("error", () => {
				if (activeSocket === socket) {
					activeSocket = null;
				}
			});
		});

		server.listen(port, "0.0.0.0", () => {
			ctx.ui.notify(`Remote RPC listening on 0.0.0.0:${port}`, "info");
			ctx.ui.setStatus("rpc", ctx.ui.theme.fg("accent", `RPC :${port}`));
		});

		server.on("error", (err) => {
			ctx.ui.notify(`Remote RPC server error: ${err.message}`, "error");
		});
	});

	pi.on("session_shutdown", async (_event: SessionShutdownEvent) => {
		if (activeSocket) {
			activeSocket.destroy();
			activeSocket = null;
		}
		if (server) {
			server.close();
			server = null;
		}
	});

	pi.registerCommand("rpc-status", {
		description: "Show remote RPC server status",
		handler: async (_args, ctx) => {
			commandCtx = ctx;
			const portStr = pi.getFlag("rpc-port") as string;
			const port = parseInt(portStr, 10) || DEFAULT_PORT;
			const connected = activeSocket !== null;
			ctx.ui.notify(`RPC server on port ${port}, client ${connected ? "connected" : "not connected"}`, "info");
		},
	});

	pi.on("agent_start", async (event: AgentStartEvent, _ctx: ExtensionContext) => {
		broadcast(event);
	});

	pi.on("agent_end", async (event: AgentEndEvent, _ctx: ExtensionContext) => {
		broadcast(event);
	});

	pi.on("turn_start", async (event: TurnStartEvent, _ctx: ExtensionContext) => {
		broadcast(event);
	});

	pi.on("turn_end", async (event: TurnEndEvent, _ctx: ExtensionContext) => {
		broadcast(event);
	});

	pi.on("message_start", async (event: MessageStartEvent, _ctx: ExtensionContext) => {
		broadcast(event);
	});

	pi.on("message_update", async (event: MessageUpdateEvent, _ctx: ExtensionContext) => {
		broadcast(event);
	});

	pi.on("message_end", async (event: MessageEndEvent, _ctx: ExtensionContext) => {
		broadcast(event);
	});

	pi.on("tool_execution_start", async (event: ToolExecutionStartEvent, _ctx: ExtensionContext) => {
		broadcast(event);
	});

	pi.on("tool_execution_update", async (event: ToolExecutionUpdateEvent, _ctx: ExtensionContext) => {
		broadcast(event);
	});

	pi.on("tool_execution_end", async (event: ToolExecutionEndEvent, _ctx: ExtensionContext) => {
		broadcast(event);
	});

	pi.on("model_select", async (event: ModelSelectEvent, _ctx: ExtensionContext) => {
		broadcast(event);
	});

	pi.on("tool_call", async (event: ToolCallEvent, _ctx: ExtensionContext) => {
		broadcast(event);
	});

	pi.on("tool_result", async (event: ToolResultEvent, _ctx: ExtensionContext) => {
		broadcast(event);
	});

	pi.on("user_bash", async (event: UserBashEvent, _ctx: ExtensionContext) => {
		broadcast(event);
	});

	pi.on("session_switch", async (event: SessionSwitchEvent, _ctx: ExtensionContext) => {
		broadcast(event);
	});

	pi.on("session_fork", async (event: SessionForkEvent, _ctx: ExtensionContext) => {
		broadcast(event);
	});

	pi.on("session_compact", async (event: SessionCompactEvent, _ctx: ExtensionContext) => {
		broadcast(event);
	});
}
