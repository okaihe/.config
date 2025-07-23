return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        { "antosha417/nvim-lsp-file-operations", config = true },
    },
    config = function()
        local lspconfig = require("lspconfig")
        local cmp_nvim_lsp = require("cmp_nvim_lsp")
        local keymap = vim.keymap
        local opts = { noremap = true, silent = true }
        local on_attach = function(client, bufnr)
            client.server_capabilities.semanticTokensProvider = nil
            opts.buffer = bufnr
            opts.desc = "Show LSP references"
            keymap.set("n", "<leader>gr", "<cmd>Telescope lsp_references<CR>", opts)
            opts.desc = "Go to declaration"
            keymap.set("n", "<leader>gD", vim.lsp.buf.declaration, opts) -- go to declaration
            opts.desc = "Show LSP definitions"
            keymap.set("n", "<leader>gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions
            opts.desc = "Show LSP implementations"
            keymap.set("n", "<leader>gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations
            opts.desc = "Show LSP type definitions"
            keymap.set("n", "<leader>gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions
            opts.desc = "See available code actions"
            keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection
            opts.desc = "Smart rename"
            keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename
            opts.desc = "Show buffer diagnostics"
            keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file
            opts.desc = "Go to previous diagnostic"
            keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer
            opts.desc = "Go to next diagnostic"
            keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer
            opts.desc = "Show documentation for what is under cursor"
            keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor
            opts.desc = "Restart LSP"
            keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
        end
        vim.keymap.set("n", "<leader>k", function()
            vim.diagnostic.config({
                virtual_lines = { current_line = true },
                virtual_text = false,
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = " ",
                        [vim.diagnostic.severity.WARN] = " ",
                        [vim.diagnostic.severity.INFO] = "󰋼 ",
                        [vim.diagnostic.severity.HINT] = "󰌵 ",
                    },
                    numhl = {
                        [vim.diagnostic.severity.ERROR] = "",
                        [vim.diagnostic.severity.WARN] = "",
                        [vim.diagnostic.severity.HINT] = "",
                        [vim.diagnostic.severity.INFO] = "",
                    },
                },
            })
            vim.api.nvim_create_autocmd("CursorMoved", {
                group = vim.api.nvim_create_augroup("line-diagnostics", { clear = true }),
                callback = function()
                    vim.diagnostic.config({ virtual_lines = false, virtual_text = true })
                    return true
                end,
            })
        end)

        vim.keymap.set("n", "<leader>y", function()
            local line_diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line(".") - 1 })
            if vim.tbl_isempty(line_diagnostics) then
                print("Keine Diagnostics auf dieser Zeile.")
                return
            end

            local messages = {}
            for _, diag in ipairs(line_diagnostics) do
                table.insert(messages, diag.message)
            end

            local all_messages = table.concat(messages, "\n")
            vim.fn.setreg("+", all_messages)
            print("Fehlermeldung kopiert!")
        end, { desc = "Diagnostics kopieren" })

        local capabilities = cmp_nvim_lsp.default_capabilities()

        lspconfig["html"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
        })

        lspconfig["pyright"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
        })

        lspconfig["dockerls"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
        })

        lspconfig["tsserver"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
        })

        lspconfig["gopls"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
        })

        lspconfig["cssls"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
        })

        lspconfig["emmet_ls"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
            filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
        })

        local languageServerPath = "/opt/homebrew/lib/node_modules/@angular/language-server/"
        lspconfig["angularls"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
            cmd = {
                "ngserver",
                "--stdio",
                "--tsProbeLocations",
                languageServerPath,
                "--ngProbeLocations",
                languageServerPath,
            },
            filetypes = { "typescript", "html", "typescriptreact", "javascript", "angular" },
        })

        lspconfig["phpactor"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
        })

        lspconfig["jdtls"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
            root_dir = lspconfig.util.root_pattern("pom.xml", "build.gradle", ".git") or vim.fn.getcwd(),
        })

        lspconfig["rust_analyzer"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
            assist = {
                importEnforceGranularity = true,
                importPrefix = "crate",
            },
            cargo = {
                allFeatures = true,
            },
            diagnostics = {
                enable = true,
                experimental = {
                    enable = true,
                },
            },
        })

        lspconfig["lua_ls"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
            settings = {
                Lua = {
                    diagnostics = {
                        globals = { "vim" },
                    },
                    workspace = {
                        library = {
                            [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                            [vim.fn.stdpath("config") .. "/lua"] = true,
                        },
                    },
                },
            },
        })

        lspconfig["texlab"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
        })
    end,
}
