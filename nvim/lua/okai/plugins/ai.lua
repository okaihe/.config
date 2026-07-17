return {
	"CopilotC-Nvim/CopilotChat.nvim",
	dependencies = { "zbirenbaum/copilot.lua", "nvim-lua/plenary.nvim" },
	build = "make tiktoken",
	opts = {
		model = "gpt-5.5",
		window = { layout = "vertical", width = 0.4 },
		trusted_tools = {
			"grep",
			"glob",
			"file",
		},
	},
	keys = {
		{ "<leader>ai", "<cmd>CopilotChatToggle<cr>", desc = "KI Chat" },
		{ "<leader>am", "<cmd>CopilotChatModels<cr>", desc = "Modell wechseln" },
		{ "<leader>ae", mode = "v", "<cmd>CopilotChatExplain<cr>", desc = "Code erklären" },
		{ "<leader>ar", mode = "v", "<cmd>CopilotChatReview<cr>", desc = "Code Review" },
		{ "<leader>af", mode = "v", "<cmd>CopilotChatFix<cr>", desc = "Fehler fixen" },
		{ "<leader>aq", "<cmd>CopilotChatReset<cr>", desc = "Chat zurücksetzen" },
		{ "<leader>ap", "<cmd>CopilotChatPrompts<cr>", desc = "Prompts anzeigen" },
	},
}
