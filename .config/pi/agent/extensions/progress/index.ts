/**
 * Progress Extension
 *
 * Tracks project progress across sessions using markdown files.
 *
 * Commands:
 * - /init or /progress-init: Create progress tracking files and inject context
 * - /progress-save: Update progress files with current session learnings
 *
 * After initialization, automatically reminds the agent to save progress
 * every N tool calls (configurable via SAVE_REMINDER_INTERVAL).
 */

import type { ExtensionAPI, ExtensionContext } from "@mariozechner/pi-coding-agent";
import * as fs from "node:fs";
import * as path from "node:path";

// Progress files to check/create
const PROGRESS_FILES = [".agent/PROGRESS.md", ".agent/LEARNINGS.md"];

// How often to remind the agent to save progress (every N tool calls)
const SAVE_REMINDER_INTERVAL = 5;

// INIT_PROMPT - Customize this prompt to specify what progress files to create and how
const INIT_PROMPT = `Create markdown files to track progress in this repository. You should:

1. Analyze the current repository structure and purpose
2. Create appropriate markdown files for tracking progress, such as:
   - .agent/PROGRESS.md - Main progress tracking file with completed tasks, current status, and next steps
   - .agent/LEARNINGS.md - Key insights, decisions, and lessons learned during development

3. For each file created, include:
   - Clear sections with headers
   - Timestamps or date markers
   - Links to relevant files where appropriate
   - Space for ongoing updates

Initialize them with any existing context you can gather from the codebase (README, existing docs, etc.).`;

// SAVE_PROMPT - Prompt for updating progress files
const SAVE_PROMPT = `Update the progress tracking markdown files with what has been accomplished and learned in this session.

Review the conversation history and:
1. Update PROGRESS.md with:
   - Tasks completed in this session
   - Current status/state of the work
   - Next steps or TODOs identified
   
2. Update LEARNINGS.md with:
   - New insights or decisions made
   - Patterns discovered
   - Issues encountered and solutions found
   - Any architectural or design decisions

Add timestamps to new entries. Be concise but capture the important details.
If the progress files don't exist yet, suggest running /init first.`;

// SAVE_REMINDER_PROMPT - Injected periodically to remind agent to save
const SAVE_REMINDER_PROMPT = `[Progress Reminder] You have made ${SAVE_REMINDER_INTERVAL} tool calls since the last save. Consider running /progress-save to update the progress tracking files with your current work and learnings.`;

export default function progressExtension(pi: ExtensionAPI): void {
	// State
	let isActive = false;
	let toolCallCount = 0;

	// Helper to inject a message and trigger LLM response
	function triggerWithPrompt(prompt: string, ctx: ExtensionContext): void {
		pi.sendMessage(
			{
				customType: "progress-command",
				content: prompt,
				display: true,
			},
			{ triggerTurn: true }
		);
		ctx.ui.notify("Progress command triggered", "info");
	}

	// Helper to inject a reminder (non-blocking, doesn't trigger new turn)
	function injectReminder(): void {
		pi.sendMessage(
			{
				customType: "progress-reminder",
				content: SAVE_REMINDER_PROMPT,
				display: true,
			},
			{ triggerTurn: false, deliverAs: "followUp" }
		);
	}

	// Check if progress files already exist
	function findExistingProgressFiles(cwd: string): string[] {
		const existing: string[] = [];
		for (const file of PROGRESS_FILES) {
			const filePath = path.join(cwd, file);
			if (fs.existsSync(filePath)) {
				existing.push(file);
			}
		}
		return existing;
	}

	// Update status indicator based on active state
	function updateStatus(ctx: ExtensionContext): void {
		if (isActive) {
			const remaining = SAVE_REMINDER_INTERVAL - (toolCallCount % SAVE_REMINDER_INTERVAL);
			ctx.ui.setStatus("progress", ctx.ui.theme.fg("success", `📝 ${remaining}`));
		} else {
			ctx.ui.setStatus("progress", ctx.ui.theme.fg("dim", "📝"));
		}
	}

	// Shared init handler
	async function handleInit(ctx: ExtensionContext): Promise<void> {
		if (!ctx.hasUI) {
			ctx.ui.notify("/init requires interactive mode", "error");
			return;
		}

		// Check if progress files already exist
		const existingFiles = findExistingProgressFiles(ctx.cwd);
		if (existingFiles.length > 0) {
			ctx.ui.notify(
				`Progress tracking already initialized. Found: ${existingFiles.join(", ")}`,
				"warning"
			);
			return;
		}

		const confirmed = await ctx.ui.confirm(
			"Initialize Progress Tracking",
			"This will create markdown files to track progress in your repository. Continue?"
		);

		if (!confirmed) {
			ctx.ui.notify("Cancelled", "info");
			return;
		}

		// Activate progress tracking
		isActive = true;
		toolCallCount = 0;
		updateStatus(ctx);

		triggerWithPrompt(INIT_PROMPT, ctx);
	}

	// /init command - create progress tracking files
	pi.registerCommand("init", {
		description: "Initialize progress tracking markdown files for the repository",
		handler: async (_args, ctx) => handleInit(ctx),
	});

	// /progress-init command - alias for /init
	pi.registerCommand("progress-init", {
		description: "Initialize progress tracking markdown files (alias for /init)",
		handler: async (_args, ctx) => handleInit(ctx),
	});

	// /progress-save command - update progress files
	pi.registerCommand("progress-save", {
		description: "Update progress markdown files with session learnings",
		handler: async (_args, ctx) => {
			if (!ctx.hasUI) {
				ctx.ui.notify("/progress-save requires interactive mode", "error");
				return;
			}

			// Check if there's any conversation to save
			const branch = ctx.sessionManager.getBranch();
			const messageCount = branch.filter((e) => e.type === "message").length;

			if (messageCount < 2) {
				ctx.ui.notify("Not enough conversation to save. Have a conversation first.", "warning");
				return;
			}

			const confirmed = await ctx.ui.confirm(
				"Save Progress",
				"Update progress files with this session's accomplishments and learnings?"
			);

			if (!confirmed) {
				ctx.ui.notify("Cancelled", "info");
				return;
			}

			// Reset tool call counter after save
			toolCallCount = 0;
			updateStatus(ctx);

			triggerWithPrompt(SAVE_PROMPT, ctx);
		},
	});

	// Track tool calls and inject reminders when active
	pi.on("tool_result", async (_event, ctx) => {
		if (!isActive) return;

		toolCallCount++;
		updateStatus(ctx);

		// Inject reminder every N tool calls
		if (toolCallCount % SAVE_REMINDER_INTERVAL === 0) {
			injectReminder();
		}
	});

	// On session start, check if progress files exist to determine active state
	pi.on("session_start", async (_event, ctx) => {
		const existingFiles = findExistingProgressFiles(ctx.cwd);
		isActive = existingFiles.length > 0;
		toolCallCount = 0;
		updateStatus(ctx);
	});
}
