return {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        "nvim-tree/nvim-web-devicons",
        "nvim-telescope/telescope-ui-select.nvim",
    },
    config = function()
        local telescope = require("telescope")
        local actions = require("telescope.actions")
        local builtin = require("telescope.builtin")
        local open_with_trouble = require("trouble.sources.telescope").open

        -- Open file in oil
        local open_selected_with_oil = function(prompt_bufnr)
            local action_state = require("telescope.actions.state")
            local entry = action_state.get_selected_entry()
            actions.close(prompt_bufnr)
            local path = entry.path or entry.filename
            local dir = vim.fn.fnamemodify(path, ":h")
            require("oil").open(dir)
        end

        telescope.setup({
            defaults = {
                path_display = { "filename_first" },
                file_ignore_patterns = {
                    ".git/",
                    "node_modules",
                    "%.angular",
                    "target",
                    "dist",
                },
                mappings = {
                    i = {
                        ["<C-k>"] = actions.move_selection_previous,
                        ["<C-j>"] = actions.move_selection_next,
                        ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
                        ["<C-u>"] = actions.preview_scrolling_up,
                        ["<C-d>"] = actions.preview_scrolling_down,
                        ["<C-t>"] = open_with_trouble,
                        ["<C-o>"] = open_selected_with_oil,
                    },
                },
            },
            pickers = {
                find_files = {
                    hidden = true,
                },
                oldfiles = {
                    prompt_title = "History",
                },
                lsp_references = {
                    theme = "dropdown",
                    initial_mode = "normal",
                },
            },
            extensions = {
                ["ui-select"] = {
                    require("telescope.themes").get_dropdown({}),
                },
            },
        })

        -- Extensions laden
        telescope.load_extension("fzf")
        telescope.load_extension("ui-select")

        local keymap = vim.keymap

        -- File navigation
        keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Finde Dateien" })
        keymap.set("n", "<leader>fb", function()
            builtin.buffers({
                sort_mru = true,
                ignore_current_buffer = true,
                cwd_only = true,
            })
        end, { desc = "Finde offene Buffer" })
        keymap.set("n", "<leader>fo", builtin.oldfiles, { desc = "History (Zuletzt geöffnet)" })

        -- Search code
        keymap.set("n", "<leader>fs", builtin.live_grep, { desc = "Suche String im Projekt" })
        keymap.set("n", "<leader>fc", builtin.grep_string, { desc = "Suche Wort unter Cursor" })

        -- Code analysis and lsp
        keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "Zeige Fehler/Warnungen (Projekt)" })
        keymap.set("n", "<leader>fi", builtin.lsp_implementations, { desc = "Finde Implementierungen (Interface)" })

        -- Help
        keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Neovim Hilfe" })
        keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "Zeige alle Keymaps" })

        -- Explore symbols
        keymap.set("n", "<leader>ss", function()
            builtin.lsp_document_symbols({
                symbols = { "Class", "Function", "Method", "Constructor", "Interface", "Module" },
            })
        end, { desc = "Gefilterte Symbole" })
        keymap.set("n", "<leader>sS", builtin.lsp_dynamic_workspace_symbols, { desc = "Projekt Struktur" })
    end,
}
