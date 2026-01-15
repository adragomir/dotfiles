import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";

export default function (pi: ExtensionAPI) {
  let currentCtx: any = null;

  // Also inject thinking instructions when prompt is sent
  pi.on("before_agent_start", async (event, ctx) => {
    const prompt = event.prompt?.toLowerCase() || "";
    
    if (prompt.includes("ultrathink")) {
      return {
        systemPrompt: `${event.systemPrompt}\n\nThe user has requested ULTRATHINK mode. This means:\n- Think EXTREMELY deeply about the problem\n- Consider multiple approaches and their tradeoffs  \n- Be extra thorough in your analysis\n- Take your time to reason through complex aspects\n- Provide comprehensive, well-thought-out responses\n`,
      };
    }
  });

  // Keyboard shortcut
  pi.registerShortcut("ctrl+u", {
    description: "Toggle ultrathink mode",
    handler: async (ctx) => {
      // Append "ULTRATHINK" to current editor text if not already there
      const currentText = ctx.ui.getEditorText?.() || "";
      if (!currentText.toLowerCase().includes("ultrathink")) {
        ctx.ui.setEditorText(currentText ? `${currentText}\n\nULTRATHINK` : "ULTRATHINK");
      }
      ctx.ui.notify("Ultrathink enabled - will be added to prompt", "success");
    },
  });
}
