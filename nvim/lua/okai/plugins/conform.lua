return {
    "stevearc/conform.nvim",
    lazy = true,
    event = { "BufReadPre", "BufNewFile" },
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
                dart = { "dart_format" },
                go = { "gofumpt", "goimports" },

                -- HIER WAREN DIE FEHLENDEN EINTRÄGE:
                typescript = { "prettier" }, -- Wichtig für .ts Files
                htmlangular = { "prettier" }, -- Wichtig, falls filetype=angular ist
            },

            -- Optional: Fallback, falls der Dateityp gar nicht gefunden wird
            format_on_save = {
                lsp_fallback = true,
                timeout_ms = 500,
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

        -- Custom Prettier Setup für Angular Files
        -- Manchmal zickt Prettier bei "angular" filetypes, wenn er den Parser nicht rät.
        -- Das hier zwingt ihn dazu.
        conform.formatters["prettier"] = {
            options = {
                -- Fügt automatisch den richtigen Parser hinzu, wenn filetype angular ist
                ft_parsers = {
                    angular = "angular",
                },
            },
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
