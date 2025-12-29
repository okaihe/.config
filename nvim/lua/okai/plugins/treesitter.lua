return {
    {
        "nvim-treesitter/nvim-treesitter",
        event = { "BufReadPre", "BufNewFile" },
        build = ":TSUpdate",
        config = function()
            local treesitter = require("nvim-treesitter.configs")
            treesitter.setup({
                modules = {},
                sync_install = false,
                ignore_install = {},

                highlight = {
                    enable = true,
                    disable = { "tex", "latex" },
                    additional_vim_regex_highlighting = false,
                },

                indent = { enable = true },
                ensure_installed = {
                    "json",
                    "javascript",
                    "typescript",
                    "tsx",
                    "yaml",
                    "html",
                    "css",
                    "markdown",
                    "markdown_inline",
                    "bash",
                    "lua",
                    "vim",
                    "dockerfile",
                    "gitignore",
                    "angular",
                    "php",
                    "rust",
                    "java",
                    "toml",
                },
                auto_install = true,
            })
        end,
    },
}
