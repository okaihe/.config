return {
	"nvim-tree/nvim-tree.lua",
	version = "*",
	lazy = false,
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		vim.g.loaded_netrw = 1
		vim.g.loaded_netrwPlugin = 1
		vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")
		require("nvim-tree").setup({
			actions = {
				open_file = {
					quit_on_open = true,
				},
			},
      renderer = {
        group_empty = true,
      }
		})
	end,
}
