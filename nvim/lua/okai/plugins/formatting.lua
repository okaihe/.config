return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>mp",
			function()
				require("conform").format({
					lsp_format = "fallback",
					async = false,
					timeout_ms = 2000,
				})
			end,
			mode = { "n", "v" },
			desc = "Datei oder Selektion manuell formatieren",
		},
	},
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			javascript = { "prettierd" },
			typescript = { "prettierd" },
			javascriptreact = { "prettierd" },
			typescriptreact = { "prettierd" },
			html = { "prettierd" },
			css = { "prettierd" },
			json = { "prettierd" },
			yaml = { "prettierd" },
			markdown = { "prettierd" },
		},
	},
	config = function(_, opts)
		require("conform").setup(opts)
	end,
}
