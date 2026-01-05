return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        { "antosha417/nvim-lsp-file-operations", config = true },
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
    },
    config = function()
        local lspconfig = require("lspconfig")
        local mason_lspconfig = require("mason-lspconfig")
        local cmp_nvim_lsp = require("cmp_nvim_lsp")

        local keymap = vim.keymap
        local opts = { noremap = true, silent = true }

        local function get_python_path()
            local venv = vim.fn.getcwd() .. "/.venv/bin/python"
            if vim.fn.filereadable(venv) == 1 then
                return venv
            else
                return "/usr/bin/python3"
            end
        end

        vim.diagnostic.config({
            signs = {
                text = {
                    [vim.diagnostic.severity.ERROR] = "✘",
                    [vim.diagnostic.severity.WARN] = "▲",
                    [vim.diagnostic.severity.HINT] = "⚑",
                    [vim.diagnostic.severity.INFO] = "»",
                },
            },
        })

        local on_attach = function(_, bufnr)
            opts.buffer = bufnr

            opts.desc = "Go to definition"
            keymap.set("n", "gd", vim.lsp.buf.definition, opts)

            opts.desc = "Show LSP references"
            keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>", opts)

            keymap.set("n", "<leader>gd", "<cmd>Telescope lsp_definitions<CR>", opts)

            opts.desc = "Go to declaration"
            keymap.set("n", "<leader>gD", vim.lsp.buf.declaration, opts)

            opts.desc = "Show LSP implementations"
            keymap.set("n", "<leader>gi", "<cmd>Telescope lsp_implementations<CR>", opts)

            opts.desc = "Show LSP type definitions"
            keymap.set("n", "<leader>gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

            opts.desc = "See available code actions"
            keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

            opts.desc = "Smart rename"
            keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

            opts.desc = "Show buffer diagnostics"
            keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

            opts.desc = "Go to previous diagnostic"
            keymap.set("n", "[d", function()
                vim.diagnostic.jump({ count = -1, float = true })
            end, opts)

            opts.desc = "Go to next diagnostic"
            keymap.set("n", "]d", function()
                vim.diagnostic.jump({ count = 1, float = true })
            end, opts)

            opts.desc = "Show documentation for what is under cursor"
            keymap.set("n", "K", vim.lsp.buf.hover, opts)

            opts.desc = "Restart LSP"
            keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)
        end

        vim.keymap.set("n", "<leader>k", function()
            vim.diagnostic.config({
                virtual_lines = { current_line = true },
                virtual_text = false,
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = "✘",
                        [vim.diagnostic.severity.WARN] = "▲",
                        [vim.diagnostic.severity.INFO] = "»",
                        [vim.diagnostic.severity.HINT] = "⚑",
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

        mason_lspconfig.setup({
            ensure_installed = {
                "angularls",
                "html",
                "pyright",
                "dockerls",
                "ts_ls",
                "gopls",
                "cssls",
                "yamlls",
                "jdtls",
                "rust_analyzer",
                "lua_ls",
                "texlab",
                "gitlab_ci_ls",
                "phpactor",
                "emmet_language_server",
                "taplo",
            },
            handlers = {
                function(server_name)
                    lspconfig[server_name].setup({
                        capabilities = capabilities,
                        on_attach = on_attach,
                    })
                end,

                ["angularls"] = function()
                    lspconfig["angularls"].setup({
                        capabilities = capabilities,
                        on_attach = on_attach,
                        filetypes = { "typescript", "html", "typescriptreact", "javascript", "angular" },
                        root_dir = lspconfig.util.root_pattern("angular.json", "project.json"),
                    })
                end,

                ["pyright"] = function()
                    lspconfig["pyright"].setup({
                        capabilities = capabilities,
                        on_attach = on_attach,
                        settings = {
                            python = {
                                pythonPath = get_python_path(),
                            },
                        },
                    })
                end,

                ["lua_ls"] = function()
                    lspconfig["lua_ls"].setup({
                        capabilities = capabilities,
                        on_attach = on_attach,
                        settings = {
                            Lua = {
                                diagnostics = {
                                    disable = { "missing-fields" },
                                },
                                workspace = {
                                    checkThirdParty = false,
                                },
                                telemetry = { enable = false },
                            },
                        },
                    })
                end,

                ["emmet_language_server"] = function()
                    lspconfig["emmet_language_server"].setup({
                        capabilities = capabilities,
                        on_attach = on_attach,
                        filetypes = {
                            "css",
                            "eruby",
                            "html",
                            "javascript",
                            "javascriptreact",
                            "less",
                            "sass",
                            "scss",
                            "svelte",
                            "pug",
                            "typescriptreact",
                            "angular",
                            "htmlangular",
                        },
                    })
                end,

                ["gitlab_ci_ls"] = function()
                    lspconfig["gitlab_ci_ls"].setup({
                        capabilities = capabilities,
                        on_attach = on_attach,
                        filetypes = { "yaml.gitlab" },
                    })
                end,
            },
        })
    end,
}
