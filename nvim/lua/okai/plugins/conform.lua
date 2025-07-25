return {
    "stevearc/conform.nvim",
    lazy = true,
    event = { "BufReadPre", "BufNewFile" }, -- to disable, comment this out
    config = function()
        local conform = require("conform")

        conform.setup({
            formatters_by_ft = {
                javascript = { "prettier" },
                javascriptreact = { "prettier" },
                typescriptreact = { "prettier" },
                svelte = { "prettier" },
                css = { "prettier" },
                html = { "prettier" },
                json = { "prettier" },
                yaml = { "prettier" },
                markdown = { "prettier" },
                graphql = { "prettier" },
                lua = { "stylua" },
                python = { "isort", "black" },
                rust = { "rustfmt" },
                java = { "google-java-format" },
                php = { "prettier" },
                xml = { "xmlformat" },
                angular = { "prettier" },
                dart = { "dart_format" },
                go = { "gofumpt", "goimports" },
            },
        })

        conform.formatters["black"] = {
            prepend_args = { "--line-length", "130" },
        }

        conform.formatters["google-java-format"] = {
            prepend_args = { "--aosp" },
        }

        conform.formatters["stylua"] = {
            prepend_args = { "--indent-type", "Spaces" },
        }

        conform.formatters["xmlformat"] = {
            prepend_args = { "--indent", "4" },
        }

        vim.keymap.set({ "n", "v" }, "<leader>dp", function()
            conform.format({
                lsp_fallback = true,
                async = true,
                timeout_ms = 1000,
            })
        end, { desc = "Format file or range (in visual mode)" })
    end,
}
