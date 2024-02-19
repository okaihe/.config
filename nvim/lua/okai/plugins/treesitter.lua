return {
	{
		"nvim-treesitter/nvim-treesitter",
		event = { "BufReadPre", "BufNewFile" },
		build = ":TSUpdate",
		dependencies = {
			"windwp/nvim-ts-autotag",
		},
		config = function()
			local treesitter = require("nvim-treesitter.configs")
			treesitter.setup({
				highlight = {
					enable = true,
				},
				indent = { enable = true },
				autotag = {
					enable = true,
					enable_rename = true,
					enable_close = true,
					enable_close_on_slash = true,
				},
				ensure_installed = {
					"json",
					"javascript",
					"typescript",
					"tsx",
					"yaml",
					"html",
					"css",
					"markdown",
					"markdown_inline",
					"bash",
					"lua",
					"vim",
					"dockerfile",
					"gitignore",
					"angular",
					"php",
				},
				context_commentstring = {
					enable = true,
					enable_autocmd = false,
				},
				auto_install = true,
			})
		end,
	},
}
