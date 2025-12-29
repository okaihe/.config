return {
    "akinsho/flutter-tools.nvim",
    lazy = false,
    dependencies = {
        "nvim-lua/plenary.nvim",
        "stevearc/dressing.nvim",
    },
    config = function()
        require("flutter-tools").setup({
            ui = {
                border = "rounded",
            },
            decorations = {
                statusline = {
                    app_version = true,
                    device = true,
                    project_config = true,
                },
            },
            lsp = {
                on_attach = function(client, bufnr)
                    local opts = { buffer = bufnr, noremap = true, silent = true }
                    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
                    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
                    vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
                end,
            },
        })

        -- Globale Flutter Keymaps
        local keymap = vim.keymap.set
        local opts = { noremap = true, silent = true, desc = "Flutter" }

        -- Starten / Stoppen
        keymap("n", "<leader>Fr", "<cmd>FlutterRun<cr>", { desc = "Flutter Run", unpack(opts) })
        keymap("n", "<leader>Fq", "<cmd>FlutterQuit<cr>", { desc = "Flutter Quit", unpack(opts) })

        -- Reloads
        keymap("n", "<leader>Fl", "<cmd>FlutterReload<cr>", { desc = "Hot Reload", unpack(opts) })
        keymap("n", "<leader>FR", "<cmd>FlutterRestart<cr>", { desc = "Full Restart", unpack(opts) })

        -- Tools
        keymap("n", "<leader>Fd", "<cmd>FlutterOpenDevTools<cr>", { desc = "Open DevTools", unpack(opts) })
        keymap("n", "<leader>Fo", "<cmd>FlutterOutlineToggle<cr>", { desc = "Toggle Outline", unpack(opts) })
    end,
}
