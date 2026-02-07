/**
 * Readlines Tool - Read partial file contents between two line numbers
 */

import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";
import { Type } from "@sinclair/typebox";
import { access, constants, open, readFile } from "fs/promises";
import { resolve, isAbsolute } from "path";

const BINARY_CHECK_BYTES = 8192;

async function isBinaryFile(path: string): Promise<boolean> {
	const handle = await open(path, "r");
	try {
		const buffer = Buffer.alloc(BINARY_CHECK_BYTES);
		const { bytesRead } = await handle.read(buffer, 0, BINARY_CHECK_BYTES, 0);
		for (let i = 0; i < bytesRead; i++) {
			if (buffer[i] === 0) return true;
		}
		return false;
	} finally {
		await handle.close();
	}
}

const readlinesSchema = Type.Object({
	path: Type.String({ description: "Path to the file to read (relative or absolute)" }),
	startLine: Type.Number({ description: "Start line number (1-indexed, inclusive)" }),
	endLine: Type.Number({ description: "End line number (1-indexed, inclusive)" }),
});

export interface ReadlinesToolDetails {
	path: string;
	startLine: number;
	endLine: number;
	totalLines: number;
	linesReturned: number;
}

export default function (pi: ExtensionAPI) {
	pi.registerTool({
		name: "readlines",
		label: "Read Lines",
		description: "Read a range of lines from a text file. Returns lines from startLine to endLine (both 1-indexed, inclusive).",
		parameters: readlinesSchema,

		async execute(_toolCallId, params, signal, _onUpdate, ctx) {
			const { path, startLine, endLine } = params as { path: string; startLine: number; endLine: number };

			if (signal?.aborted) {
				throw new Error("Operation aborted");
			}

			// Validate line numbers
			if (startLine < 1) {
				throw new Error("startLine must be >= 1");
			}
			if (endLine < startLine) {
				throw new Error("endLine must be >= startLine");
			}

			// Resolve path
			const absolutePath = isAbsolute(path) ? path : resolve(ctx.cwd, path);

			// Check file exists and is readable
			await access(absolutePath, constants.R_OK);

			// Check for binary file
			if (await isBinaryFile(absolutePath)) {
				throw new Error(`File appears to be binary: ${path}. Use 'read' tool for images or 'bash' with xxd/hexdump for binary inspection.`);
			}

			// Read file
			const content = await readFile(absolutePath, "utf-8");
			const allLines = content.split("\n");
			const totalLines = allLines.length;

			// Validate range against file length
			if (startLine > totalLines) {
				throw new Error(`startLine ${startLine} is beyond end of file (${totalLines} lines)`);
			}

			// Convert to 0-indexed and clamp endLine
			const start = startLine - 1;
			const end = Math.min(endLine - 1, totalLines - 1);

			// Extract lines
			const selectedLines = allLines.slice(start, end + 1);
			const outputText = selectedLines.join("\n");

			const details: ReadlinesToolDetails = {
				path: absolutePath,
				startLine,
				endLine: end + 1,
				totalLines,
				linesReturned: selectedLines.length,
			};

			return {
				content: [{ type: "text", text: outputText }],
				details,
			};
		},
	});
}
