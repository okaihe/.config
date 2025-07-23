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
        vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { silent = true })
        require("nvim-tree").setup({
            actions = {
                open_file = {
                    quit_on_open = true,
                },
            },
            renderer = {
                group_empty = true,
            },
            update_focused_file = {
                enable = true,
                update_root = false,
                ignore_list = {},
            },
            git = {
                enable = false,
                ignore = true,
                timeout = 500,
            },
            view = { adaptive_size = true },
            filters = {
                custom = { "__pycache__", ".DS_Store", ".pytest_cache" },
            },
        })
    end,
}
