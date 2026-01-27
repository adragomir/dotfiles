/**
 * LSP Extension for Pi Coding Agent
 *
 * Provides Language Server Protocol integration for code intelligence.
 * Supports: clangd (C/C++), rust-analyzer (Rust), gopls (Go), ty (Python), typescript-language-server (TS/JS)
 */

import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";
import { Type } from "@sinclair/typebox";
import { Text } from "@mariozechner/pi-tui";
import { spawn, type ChildProcess } from "node:child_process";
import { existsSync } from "node:fs";
import { readFile } from "node:fs/promises";
import { join, dirname, resolve, relative } from "node:path";
import {
	createMessageConnection,
	StreamMessageReader,
	StreamMessageWriter,
	type MessageConnection,
} from "vscode-languageserver-protocol/node";
import {
	InitializeRequest,
	InitializedNotification,
	ShutdownRequest,
	ExitNotification,
	DefinitionRequest,
	WorkspaceSymbolRequest,
	DidOpenTextDocumentNotification,
	PublishDiagnosticsNotification,
	WorkspaceDiagnosticRequest,
	type InitializeParams,
	type InitializeResult,
	type Location,
	type LocationLink,
	type SymbolInformation,
	type WorkspaceSymbol,
	type Diagnostic,
	type PublishDiagnosticsParams,
	type WorkspaceDiagnosticReport,
	type WorkspaceFullDocumentDiagnosticReport,
	DiagnosticSeverity,
	DocumentDiagnosticReportKind,
} from "vscode-languageserver-protocol";

// ============================================================================
// Configuration
// ============================================================================

type SeverityLevel = "error" | "warning" | "info" | "hint";

const CONFIG = {
	minDiagnosticSeverity: "warning" as SeverityLevel,
	diagnosticWaitMs: 2000,
};

const SEVERITY_VALUES: Record<SeverityLevel, number> = {
	error: DiagnosticSeverity.Error,
	warning: DiagnosticSeverity.Warning,
	info: DiagnosticSeverity.Information,
	hint: DiagnosticSeverity.Hint,
};

const SEVERITY_NAMES: Record<number, string> = {
	[DiagnosticSeverity.Error]: "error",
	[DiagnosticSeverity.Warning]: "warning",
	[DiagnosticSeverity.Information]: "info",
	[DiagnosticSeverity.Hint]: "hint",
};

// ============================================================================
// LSP Server Configuration
// ============================================================================

interface LspServerConfig {
	name: string;
	command: string[];
	rootPatterns: string[];
	extensions: string[];
}

const LSP_SERVERS: LspServerConfig[] = [
	{
		name: "rust-analyzer",
		command: ["rust-analyzer"],
		rootPatterns: ["Cargo.toml", "rust-project.json"],
		extensions: [".rs"],
	},
	{
		name: "gopls",
		command: ["gopls", "serve"],
		rootPatterns: ["go.mod", "go.work"],
		extensions: [".go"],
	},
	{
		name: "ty",
		command: ["ty", "server"],
		rootPatterns: ["pyproject.toml", "setup.py", "requirements.txt", "Pipfile", ".python-version"],
		extensions: [".py", ".pyi"],
	},
	{
		name: "typescript-language-server",
		command: ["typescript-language-server", "--stdio"],
		rootPatterns: ["tsconfig.json", "jsconfig.json", "package.json"],
		extensions: [".ts", ".tsx", ".js", ".jsx", ".mts", ".mjs", ".cts", ".cjs"],
	},
	{
		name: "clangd",
		command: ["clangd", "--background-index"],
		rootPatterns: ["compile_commands.json", ".clangd", "CMakeLists.txt", "Makefile", ".git"],
		extensions: [".c", ".cc", ".cpp", ".cxx", ".h", ".hpp", ".hxx"],
	},
];

// ============================================================================
// Project Detection
// ============================================================================

interface ProjectInfo {
	root: string;
	server: LspServerConfig;
}

function findProjectRoot(cwd: string): ProjectInfo | null {
	let currentDir = resolve(cwd);
	const root = "/";

	while (currentDir !== root) {
		for (const server of LSP_SERVERS) {
			for (const pattern of server.rootPatterns) {
				const candidate = join(currentDir, pattern);
				if (existsSync(candidate)) {
					return { root: currentDir, server };
				}
			}
		}
		const parent = dirname(currentDir);
		if (parent === currentDir) break;
		currentDir = parent;
	}

	return null;
}

// ============================================================================
// LSP Server Manager
// ============================================================================

interface LspServer {
	process: ChildProcess;
	connection: MessageConnection;
	config: LspServerConfig;
	root: string;
	initialized: boolean;
	ready: Promise<void>;
	capabilities: InitializeResult["capabilities"];
	diagnostics: Map<string, Diagnostic[]>;
	openDocuments: Set<string>;
}

let activeServer: LspServer | null = null;

async function startServer(info: ProjectInfo): Promise<LspServer> {
	const { root, server: config } = info;

	const proc = spawn(config.command[0], config.command.slice(1), {
		cwd: root,
		stdio: ["pipe", "pipe", "pipe"],
		env: { ...process.env },
	});

	const connection = createMessageConnection(
		new StreamMessageReader(proc.stdout!),
		new StreamMessageWriter(proc.stdin!)
	);

	let resolveReady!: () => void;
	let rejectReady!: (err: Error) => void;
	const ready = new Promise<void>((resolve, reject) => {
		resolveReady = resolve;
		rejectReady = reject;
	});
	ready.catch(() => {});

	const server: LspServer = {
		process: proc,
		connection,
		config,
		root,
		initialized: false,
		ready,
		capabilities: {},
		diagnostics: new Map(),
		openDocuments: new Set(),
	};

	// Listen for push diagnostics (fallback when workspace diagnostics not supported)
	connection.onNotification(PublishDiagnosticsNotification.type, (params: PublishDiagnosticsParams) => {
		const path = uriToPath(params.uri);
		server.diagnostics.set(path, params.diagnostics);
	});

	proc.on("error", (err) => {
		if (!server.initialized) rejectReady(err);
	});

	proc.on("exit", (code) => {
		if (activeServer === server) activeServer = null;
		if (!server.initialized) {
			rejectReady(new Error(`LSP server exited with code ${code}`));
		}
	});

	connection.listen();

	const initParams: InitializeParams = {
		processId: process.pid,
		rootUri: `file://${root}`,
		rootPath: root,
		capabilities: {
			textDocument: {
				definition: { dynamicRegistration: false },
				references: { dynamicRegistration: false },
				hover: { dynamicRegistration: false },
				publishDiagnostics: {
					relatedInformation: true,
					tagSupport: { valueSet: [1, 2] },
				},
				diagnostic: {
					dynamicRegistration: false,
				},
			},
			workspace: {
				symbol: { dynamicRegistration: false },
				diagnostics: {
					refreshSupport: true,
				},
			},
		},
		workspaceFolders: [{ uri: `file://${root}`, name: config.name }],
	};

	const timeoutPromise = new Promise<never>((_, reject) => {
		setTimeout(() => reject(new Error("LSP initialization timeout")), 30000);
	});

	const initResult = await Promise.race([
		connection.sendRequest(InitializeRequest.type, initParams),
		timeoutPromise,
	]) as InitializeResult;

	server.capabilities = initResult.capabilities;

	connection.sendNotification(InitializedNotification.type, {});
	server.initialized = true;
	resolveReady();

	return server;
}

function stopServer(server: LspServer): void {
	try {
		server.connection.sendRequest(ShutdownRequest.type).catch(() => {});
		server.connection.sendNotification(ExitNotification.type);
		server.connection.dispose();
		server.process.kill();
	} catch {
		// Ignore errors during shutdown
	}
}

async function ensureServer(cwd: string): Promise<LspServer | null> {
	const info = findProjectRoot(cwd);
	if (!info) return null;

	if (activeServer && activeServer.root === info.root && activeServer.config.name === info.server.name) {
		await activeServer.ready;
		return activeServer;
	}

	if (activeServer) {
		stopServer(activeServer);
		activeServer = null;
	}

	try {
		activeServer = await startServer(info);
		return activeServer;
	} catch {
		return null;
	}
}

function supportsWorkspaceDiagnostics(server: LspServer): boolean {
	const provider = server.capabilities.diagnosticProvider;
	return typeof provider === "object" && provider !== null && "workspaceDiagnostics" in provider && provider.workspaceDiagnostics === true;
}

// ============================================================================
// LSP Operations
// ============================================================================

function uriToPath(uri: string): string {
	return uri.replace(/^file:\/\//, "");
}

function isLocation(item: unknown): item is Location {
	return item !== null && typeof item === "object" && "uri" in item && "range" in item;
}

function isLocationLink(item: unknown): item is LocationLink {
	return item !== null && typeof item === "object" && "targetUri" in item;
}

function normalizeLocations(result: Location | Location[] | LocationLink[] | null): Location[] {
	if (!result) return [];

	if (Array.isArray(result)) {
		return result.map((item) => {
			if (isLocationLink(item)) {
				return {
					uri: item.targetUri,
					range: item.targetSelectionRange,
				};
			}
			return item;
		});
	}

	if (isLocation(result)) {
		return [result];
	}

	return [];
}

function getLanguageId(file: string, config: LspServerConfig): string {
	const ext = file.slice(file.lastIndexOf(".")).toLowerCase();
	switch (config.name) {
		case "clangd":
			return ext === ".c" ? "c" : "cpp";
		case "rust-analyzer":
			return "rust";
		case "gopls":
			return "go";
		case "ty":
			return "python";
		case "typescript-language-server":
			return ext.includes("ts") ? "typescript" : "javascript";
		default:
			return "plaintext";
	}
}

async function openDocument(server: LspServer, file: string): Promise<void> {
	const uri = `file://${file}`;
	if (server.openDocuments.has(uri)) return;

	const text = await readFile(file, "utf-8");
	server.connection.sendNotification(DidOpenTextDocumentNotification.type, {
		textDocument: {
			uri,
			languageId: getLanguageId(file, server.config),
			version: 1,
			text,
		},
	});
	server.openDocuments.add(uri);
}

async function findDefinition(server: LspServer, file: string, line: number, character: number): Promise<Location[]> {
	await openDocument(server, file);

	const result = await server.connection.sendRequest(DefinitionRequest.type, {
		textDocument: { uri: `file://${file}` },
		position: { line, character },
	});

	return normalizeLocations(result);
}

async function findWorkspaceSymbol(server: LspServer, query: string): Promise<(SymbolInformation | WorkspaceSymbol)[]> {
	const result = await server.connection.sendRequest(WorkspaceSymbolRequest.type, { query });
	return result ?? [];
}

// ============================================================================
// Diagnostics
// ============================================================================

interface FormattedDiagnostic {
	file: string;
	line: number;
	column: number;
	severity: string;
	message: string;
	code?: string | number;
}

function filterDiagnostics(diagnostics: Diagnostic[], minSeverity: SeverityLevel): Diagnostic[] {
	const minValue = SEVERITY_VALUES[minSeverity];
	return diagnostics.filter((d) => (d.severity ?? DiagnosticSeverity.Error) <= minValue);
}

function formatDiagnostic(file: string, d: Diagnostic, root: string): FormattedDiagnostic {
	const relPath = relative(root, file) || file;
	return {
		file: relPath,
		line: d.range.start.line + 1,
		column: d.range.start.character + 1,
		severity: SEVERITY_NAMES[d.severity ?? DiagnosticSeverity.Error] ?? "error",
		message: d.message,
		code: d.code as string | number | undefined,
	};
}

async function getWorkspaceDiagnostics(server: LspServer): Promise<FormattedDiagnostic[]> {
	const minSeverity = CONFIG.minDiagnosticSeverity;

	if (supportsWorkspaceDiagnostics(server)) {
		// Use workspace/diagnostic request
		const result = await server.connection.sendRequest(WorkspaceDiagnosticRequest.type, {
			previousResultIds: [],
		}) as WorkspaceDiagnosticReport;

		const diagnostics: FormattedDiagnostic[] = [];
		for (const item of result.items) {
			if (item.kind === DocumentDiagnosticReportKind.Full) {
				const fullReport = item as WorkspaceFullDocumentDiagnosticReport;
				const file = uriToPath(fullReport.uri);
				const filtered = filterDiagnostics(fullReport.items, minSeverity);
				for (const d of filtered) {
					diagnostics.push(formatDiagnostic(file, d, server.root));
				}
			}
		}
		return diagnostics;
	}

	// Fallback: use cached push diagnostics
	// Wait a bit for any pending diagnostics
	await new Promise((r) => setTimeout(r, CONFIG.diagnosticWaitMs));

	const diagnostics: FormattedDiagnostic[] = [];
	for (const [file, diags] of server.diagnostics) {
		const filtered = filterDiagnostics(diags, minSeverity);
		for (const d of filtered) {
			diagnostics.push(formatDiagnostic(file, d, server.root));
		}
	}
	return diagnostics;
}

// ============================================================================
// Symbol Search (grep-based fallback + LSP workspace/symbol)
// ============================================================================

async function findSymbolInFiles(cwd: string, symbol: string, server: LspServer | null): Promise<string | null> {
	if (server) {
		try {
			const symbols = await findWorkspaceSymbol(server, symbol);
			const exact = symbols.find((s) => s.name === symbol);
			if (exact) {
				const loc = "location" in exact ? exact.location : null;
				if (loc) {
					const path = uriToPath(loc.uri);
					const line = loc.range.start.line;
					const char = loc.range.start.character;
					return `${path}:${line + 1}:${char + 1}`;
				}
			}
		} catch {
			// Fall through to grep
		}
	}

	const { execSync } = await import("node:child_process");

	const patterns = [
		`^\\s*(pub\\s+)?(async\\s+)?fn\\s+${symbol}\\s*[<(]`,
		`^\\s*(pub\\s+)?(struct|enum|trait|type)\\s+${symbol}\\b`,
		`^\\s*(export\\s+)?(async\\s+)?function\\s+${symbol}\\s*[<(]`,
		`^\\s*(export\\s+)?(class|interface|type|enum)\\s+${symbol}\\b`,
		`^\\s*def\\s+${symbol}\\s*\\(`,
		`^\\s*class\\s+${symbol}\\s*[:(]`,
		`^\\s*(static\\s+|virtual\\s+)*\\w+\\s+${symbol}\\s*\\(`,
		`^\\s*(struct|class|enum|typedef)\\s+${symbol}\\b`,
	];

	const combined = patterns.join("|");

	try {
		const cmd = `rg -n -e '${combined}' --type-add 'code:*.{ts,tsx,js,jsx,py,rs,go,c,cpp,cc,cxx,h,hpp,hxx}' -t code . 2>/dev/null || grep -rn -E '${combined}' --include='*.ts' --include='*.tsx' --include='*.js' --include='*.jsx' --include='*.py' --include='*.rs' --include='*.go' --include='*.c' --include='*.cpp' --include='*.h' --include='*.hpp' . 2>/dev/null`;

		const output = execSync(cmd, { cwd, encoding: "utf-8", maxBuffer: 10 * 1024 * 1024 });
		const lines = output.trim().split("\n").filter(Boolean);

		if (lines.length > 0) {
			const match = lines[0].match(/^([^:]+):(\d+):/);
			if (match) {
				return `${match[1]}:${match[2]}:1`;
			}
		}
	} catch {
		// No matches
	}

	return null;
}

// ============================================================================
// Extension
// ============================================================================

export default function lspExtension(pi: ExtensionAPI) {
	pi.on("session_shutdown", async () => {
		if (activeServer) {
			stopServer(activeServer);
			activeServer = null;
		}
	});

	pi.registerCommand("lsp-start", {
		description: "Start or restart the LSP server for the current project",
		handler: async (_args, ctx) => {
			const info = findProjectRoot(ctx.cwd);

			if (!info) {
				ctx.ui.notify("No supported project found", "error");
				return;
			}

			if (activeServer) {
				stopServer(activeServer);
				activeServer = null;
			}

			ctx.ui.notify(`Starting ${info.server.name} for ${info.root}...`, "info");

			try {
				activeServer = await startServer(info);
				const workspaceDiag = supportsWorkspaceDiagnostics(activeServer) ? " (workspace diagnostics)" : "";
				ctx.ui.notify(`${info.server.name} ready${workspaceDiag}`, "info");
			} catch (err) {
				ctx.ui.notify(`Failed to start ${info.server.name}: ${err}`, "error");
			}
		},
	});

	pi.registerCommand("lsp-stop", {
		description: "Stop the LSP server",
		handler: async (_args, ctx) => {
			if (!activeServer) {
				ctx.ui.notify("No LSP server running", "info");
				return;
			}

			const name = activeServer.config.name;
			stopServer(activeServer);
			activeServer = null;
			ctx.ui.notify(`${name} stopped`, "info");
		},
	});

	pi.registerCommand("lsp-status", {
		description: "Show LSP server status",
		handler: async (_args, ctx) => {
			if (!activeServer) {
				const info = findProjectRoot(ctx.cwd);
				if (info) {
					ctx.ui.notify(`No LSP running. Detected: ${info.server.name} (${info.root})`, "info");
				} else {
					ctx.ui.notify("No LSP running. No supported project detected.", "info");
				}
				return;
			}

			const workspaceDiag = supportsWorkspaceDiagnostics(activeServer) ? ", workspace diagnostics" : "";
			ctx.ui.notify(`${activeServer.config.name} running at ${activeServer.root}${workspaceDiag}`, "info");
		},
	});

	// lsp_location tool
	pi.registerTool({
		name: "lsp_location",
		label: "LSP Location",
		description:
			"Find the location (file, line, column) where a symbol is defined. " +
			"Use this to navigate to function definitions, type declarations, etc. " +
			"Starts the appropriate LSP server automatically if needed.",
		parameters: Type.Object({
			symbol: Type.String({ description: "The symbol name to look up (function, type, variable, etc.)" }),
			file: Type.Optional(Type.String({ description: "Optional: file path where the symbol is used (for more accurate results)" })),
			line: Type.Optional(Type.Number({ description: "Optional: line number (0-indexed) where the symbol appears" })),
			character: Type.Optional(Type.Number({ description: "Optional: character position (0-indexed) where the symbol starts" })),
		}),

		async execute(_toolCallId, params, _onUpdate, ctx, _signal) {
			const { symbol, file, line, character } = params;

			const server = await ensureServer(ctx.cwd);

			let location: string | null = null;

			if (server && file && line !== undefined && character !== undefined) {
				try {
					const fullPath = resolve(ctx.cwd, file);
					const definitions = await findDefinition(server, fullPath, line, character);

					if (definitions.length > 0) {
						const def = definitions[0];
						const path = uriToPath(def.uri);
						location = `${path}:${def.range.start.line + 1}:${def.range.start.character + 1}`;
					}
				} catch {
					// Fall through to symbol search
				}
			}

			if (!location) {
				location = await findSymbolInFiles(ctx.cwd, symbol, server);
			}

			if (!location) {
				return {
					content: [{ type: "text", text: `Symbol '${symbol}' not found` }],
					details: { symbol, found: false },
				};
			}

			const [foundFile, foundLine, foundCol] = location.split(":");
			return {
				content: [
					{
						type: "text",
						text: `${symbol} is defined at:\n  File: ${foundFile}\n  Line: ${foundLine}\n  Column: ${foundCol || "1"}`,
					},
				],
				details: {
					symbol,
					found: true,
					file: foundFile,
					line: parseInt(foundLine, 10),
					column: parseInt(foundCol || "1", 10),
				},
			};
		},

		renderCall(args, theme) {
			let text = theme.fg("toolTitle", theme.bold("lsp_location "));
			text += theme.fg("accent", args.symbol);
			if (args.file) {
				text += theme.fg("muted", ` in ${args.file}`);
				if (args.line !== undefined) {
					text += theme.fg("dim", `:${args.line}`);
				}
			}
			return new Text(text, 0, 0);
		},

		renderResult(result, { expanded }, theme) {
			const details = result.details as { symbol: string; found: boolean; file?: string; line?: number; column?: number } | undefined;

			if (!details?.found) {
				return new Text(theme.fg("warning", `Symbol '${details?.symbol}' not found`), 0, 0);
			}

			let text = theme.fg("success", "✓ ") + theme.fg("accent", details.symbol);
			text += "\n  " + theme.fg("dim", `${details.file}:${details.line}:${details.column}`);

			return new Text(text, 0, 0);
		},
	});

	// lsp_diagnostics tool
	pi.registerTool({
		name: "lsp_diagnostics",
		label: "LSP Diagnostics",
		description:
			"Get diagnostics (errors, warnings) for the entire workspace. " +
			"Use this after making code modifications to verify they don't introduce errors. " +
			`Reports diagnostics at severity level '${CONFIG.minDiagnosticSeverity}' and above. ` +
			"Starts the appropriate LSP server automatically if needed.",
		parameters: Type.Object({}),

		async execute(_toolCallId, _params, _onUpdate, ctx, _signal) {
			const server = await ensureServer(ctx.cwd);

			if (!server) {
				return {
					content: [{ type: "text", text: "No LSP server available for this project" }],
					details: { error: true, diagnostics: [] },
				};
			}

			try {
				const diagnostics = await getWorkspaceDiagnostics(server);

				if (diagnostics.length === 0) {
					return {
						content: [{ type: "text", text: `No diagnostics (${CONFIG.minDiagnosticSeverity} or above) in workspace` }],
						details: { error: false, count: 0, diagnostics: [] },
					};
				}

				let text = `Found ${diagnostics.length} diagnostic(s):\n\n`;
				for (const d of diagnostics) {
					const code = d.code ? ` [${d.code}]` : "";
					text += `${d.file}:${d.line}:${d.column}: ${d.severity}${code}: ${d.message}\n`;
				}

				return {
					content: [{ type: "text", text }],
					details: {
						error: false,
						count: diagnostics.length,
						diagnostics,
					},
				};
			} catch (err) {
				return {
					content: [{ type: "text", text: `Failed to get diagnostics: ${err}` }],
					details: { error: true, diagnostics: [] },
				};
			}
		},

		renderCall(_args, theme) {
			return new Text(theme.fg("toolTitle", theme.bold("lsp_diagnostics")), 0, 0);
		},

		renderResult(result, { expanded }, theme) {
			const details = result.details as { error?: boolean; count?: number; diagnostics?: FormattedDiagnostic[] } | undefined;

			if (details?.error) {
				const content = result.content[0];
				const msg = content?.type === "text" ? content.text : "Error";
				return new Text(theme.fg("error", msg), 0, 0);
			}

			const count = details?.count ?? 0;
			if (count === 0) {
				return new Text(theme.fg("success", "✓ No diagnostics"), 0, 0);
			}

			let text = theme.fg("warning", `⚠ ${count} diagnostic(s)`);

			if (expanded && details?.diagnostics) {
				for (const d of details.diagnostics.slice(0, 20)) {
					const sevColor = d.severity === "error" ? "error" : "warning";
					text += `\n  ${theme.fg("dim", `${d.file}:${d.line}`)} ${theme.fg(sevColor, d.severity)}: ${d.message}`;
				}
				if (details.diagnostics.length > 20) {
					text += theme.fg("muted", `\n  ... and ${details.diagnostics.length - 20} more`);
				}
			}

			return new Text(text, 0, 0);
		},
	});
}
