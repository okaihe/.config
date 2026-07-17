local parsers = {
	"lua",
	"vim",
	"vimdoc",
	"query",
	"markdown",
	"markdown_inline",
	"yaml",
	"json",
	"html",
	"html_tags",
	"css",
	"scss",
	"typescript",
	"javascript",
	"tsx",
	"angular",
}

return {
	"neovim-treesitter/nvim-treesitter",
	dependencies = {
		"neovim-treesitter/treesitter-parser-registry",
	},
	lazy = false,
	build = ":TSUpdate",
	config = function()
		local treesitter = require("nvim-treesitter")
		treesitter.install(parsers)
		vim.treesitter.language.register("angular", "htmlangular")
		local group = vim.api.nvim_create_augroup("user_treesitter", { clear = true })
		vim.api.nvim_create_autocmd("FileType", {
			group = group,
			pattern = "*",
			callback = function(event)
				local filename = vim.api.nvim_buf_get_name(event.buf)
				local ok, stats = pcall(vim.uv.fs_stat, filename)

				if ok and stats and stats.size > 100 * 1024 then
					return
				end
				pcall(vim.treesitter.start, event.buf)
			end,
		})
	end,
}
