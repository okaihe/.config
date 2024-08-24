return {
    "akinsho/flutter-tools.nvim",
    lazy = false,
    dependencies = {
        "nvim-lua/plenary.nvim",
        "stevearc/dressing.nvim", -- optional for vim.ui.select
    },
    config = function()
        require("flutter-tools").setup({
            decorations = {
                statusline = {
                    app_version = true,
                    device = true,
                    project_config = true,
                },
            },
        })

        local opts = { noremap = true, silent = true }
        -- keymap("n", "<leader>e", ":Explore <cr>", opts)
        vim.cmd([[ nnoremap <leader>ca <Cmd>lua vim.lsp.buf.code_action()<CR> ]])
        vim.cmd([[ xnoremap <leader>ca <Cmd>lua vim.lsp.buf.range_code_action()<CR> ]])
        vim.api.nvim_set_keymap("n", "<leader>fo", ":FlutterOutlineToggle<cr>", opts)
        vim.api.nvim_set_keymap("n", "<leader>fd", ":FlutterOpenDevTools<cr>", opts)
        vim.api.nvim_set_keymap("n", "<leader>fR", ":FlutterRun<cr>", opts)
        vim.api.nvim_set_keymap("n", "<leader>fl", ":FlutterReload<cr>", opts)
        vim.api.nvim_set_keymap("n", "<leader>fr", ":FlutterRestart<cr>", opts)
        vim.api.nvim_set_keymap("n", "<leader>fq", ":FlutterQuit<cr>", opts)
    end,
}
