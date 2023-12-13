return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")

		telescope.setup({
			defaults = {
				path_display = { "truncate " },
				mappings = {
					i = {
						["<C-k>"] = actions.move_selection_previous, -- move to prev result
						["<C-j>"] = actions.move_selection_next, -- move to next result
						["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
					},
				},
			},
		})

		telescope.load_extension("fzf")
		local keymap = vim.keymap
		keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
		keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
		keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
		keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
		keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Find a buffer" })
		keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Find a help tag" })

		-- Telescope Highlight Groups
    -- TelescopeNormal
    -- TelescopeBorder
    -- TelescopeSelectionCaret
    -- TelescopeMatching
    -- TelescopePromptNormal
    -- TelescopePromptTitle
    -- TelescopePromptPrefix
    -- TelescopePromptBorder
    -- TelescopePreviewTitle
    -- TelescopePreviewBorder
    -- TelescopeResultsTitle
    -- TelescopeResultsBorder

    local color1 = "#141718"
    local color2 = "#191b1c"
    local color3 = "#8bba7e"

    -- Prompt
		vim.api.nvim_command("highlight TelescopePromptBorder guifg=" .. color1)
		vim.api.nvim_command("highlight TelescopePromptBorder guibg=" .. color1)
		vim.api.nvim_command("highlight TelescopePromptNormal guibg=" .. color1)

    -- Selection
		vim.api.nvim_command("highlight TelescopeSelection guibg=" .. color1)

    -- Results
		vim.api.nvim_command("highlight TelescopeResultsBorder guifg=" .. color2)
		vim.api.nvim_command("highlight TelescopeResultsBorder guibg=" .. color2)
		vim.api.nvim_command("highlight TelescopeNormal guibg=" .. color2)

    -- Preview
		vim.api.nvim_command("highlight TelescopePreviewBorder guifg=" .. color2)
		vim.api.nvim_command("highlight TelescopePreviewBorder guibg=" .. color2)

    -- Titles
		vim.api.nvim_command("highlight TelescopeResultsTitle guibg=" .. color3)
		vim.api.nvim_command("highlight TelescopePromptTitle guibg=" .. color3)
		vim.api.nvim_command("highlight TelescopePreviewTitle guibg=" .. color3)
	end,
}
