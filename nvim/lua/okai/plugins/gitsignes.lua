return {
    "lewis6991/gitsigns.nvim",
    config = function()
        require("gitsigns").setup({
            -- signs = {
            -- 	add = { text = "+" },
            -- 	change = { text = "~" },
            -- 	delete = { text = "-" },
            -- 	topdelete = { text = "‾" },
            -- 	changedelete = { text = "/" },
            -- 	untracked = { text = "┆" },
            -- },
            signs = {
                add = { text = "▍" },
                change = { text = "▍" },
                delete = { text = "▍" },
                topdelete = { text = "▍" },
                changedelete = { text = "▍" },
                untracked = { text = "▍" },
            },
            signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
            numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
            linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
            word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
            watch_gitdir = {
                follow_files = true,
            },
            attach_to_untracked = true,
            current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
            current_line_blame_opts = {
                virt_text = true,
                virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
                delay = 1000,
                ignore_whitespace = false,
            },
            current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
            sign_priority = 6,
            update_debounce = 100,
            status_formatter = nil, -- Use default
            max_file_length = 40000, -- Disable if file is longer than this (in lines)
            preview_config = {
                -- Options passed to nvim_open_win
                border = "single",
                style = "minimal",
                relative = "cursor",
                row = 0,
                col = 1,
            },
        })

        local gs = package.loaded.gitsigns
        local keymap = vim.keymap
        keymap.set("n", "<leader>lb", gs.toggle_current_line_blame, { desc = "Toggle line blame" })
        keymap.set("n", "<leader>hp", gs.preview_hunk, { desc = "Preview hunk" })
        keymap.set("n", "<leader>hd", gs.diffthis, { desc = "Diff this" })
        keymap.set("n", "<leader>td", gs.toggle_deleted, { desc = "Toggle deleted" })
        keymap.set("n", "<leader>hb", function()
            gs.blame_line({ full = true })
        end, { desc = "Blame line full" })
    end,
}
