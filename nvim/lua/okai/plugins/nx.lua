return {
	"Equilibris/nx.nvim",
	dependencies = {
		"nvim-telescope/telescope.nvim",
		"akinsho/toggleterm.nvim",
	},
	config = function()
		require("nx").setup({
			nx_cmd_root = "npx nx",
			command_runner = require("nx.command-runners").toggleterm_runner(),
		})
	end,
	keys = {
		{ "<leader>nx", "<cmd>Telescope nx actions<CR>", desc = "Nx Actions" },
	},
}
