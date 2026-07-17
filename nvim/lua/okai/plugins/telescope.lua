return {
	"nvim-telescope/telescope.nvim",
	version = "*",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
		},
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")
		telescope.setup({
			defaults = {
				borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
				mappings = {
					i = {
						["<C-k>"] = actions.move_selection_previous,
						["<C-j>"] = actions.move_selection_next,
						["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
					},
				},
			},
		})
		pcall(telescope.load_extension, "fzf")
		local builtin = require("telescope.builtin")
		local map = vim.keymap.set
		map("n", "<leader>ff", builtin.find_files, { desc = "Fuzzy Find Files" }) -- Find Files
		map("n", "<leader>fg", builtin.live_grep, { desc = "Find Text (Grep)" }) -- Find Grep
		map("n", "<leader>fb", builtin.buffers, { desc = "Find Active Buffers" }) -- Find Buffers
		map("n", "<leader>fh", builtin.help_tags, { desc = "Find Help Tags" }) -- Find Help
		map("n", "<leader>fr", builtin.oldfiles, { desc = "Find Recent Files" }) -- Find Recent
	end,
}
