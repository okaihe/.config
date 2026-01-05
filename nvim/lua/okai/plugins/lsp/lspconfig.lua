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

        vim.diagnostic.config({
            virtual_text = true,
            signs = {
                text = {
                    [vim.diagnostic.severity.ERROR] = "✘",
                    [vim.diagnostic.severity.WARN] = "▲",
                    [vim.diagnostic.severity.HINT] = "⚑",
                    [vim.diagnostic.severity.INFO] = "»",
                },
            },
        })

        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
            callback = function(ev)
                local opts = { buffer = ev.buf, silent = true }
                local keymap = vim.keymap

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

                opts.desc = "Copy diagnostics to clipboard"
                keymap.set("n", "<leader>y", function()
                    local line = vim.fn.line(".") - 1
                    local diagnostics = vim.diagnostic.get(0, { lnum = line })

                    if #diagnostics == 0 then
                        print("Keine Fehler in dieser Zeile gefunden.")
                        return
                    end

                    local error_messages = {}
                    for _, diag in ipairs(diagnostics) do
                        -- Format: [Source] Fehlertext (Code)
                        local source = diag.source or "LSP"
                        local msg = string.format("[%s] %s", source, diag.message)
                        table.insert(error_messages, msg)
                    end

                    local text_to_copy = table.concat(error_messages, "\n")
                    vim.fn.setreg("+", text_to_copy) -- "+" ist die System-Zwischenablage
                    print("Diagnose kopiert!")
                end, opts)

                opts.desc = "Go to definition"
                keymap.set("n", "gd", vim.lsp.buf.definition, opts)

                opts.desc = "Show LSP references"
                keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>", opts)

                opts.desc = "Go to declaration"
                keymap.set("n", "<leader>gD", vim.lsp.buf.declaration, opts)

                opts.desc = "Show documentation"
                keymap.set("n", "K", vim.lsp.buf.hover, opts)

                opts.desc = "Smart rename"
                keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

                opts.desc = "Code actions"
                keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

                opts.desc = "Show diagnostics"
                keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

                keymap.set("n", "[d", function()
                    vim.diagnostic.jump({ count = -1, float = true })
                end, opts)
                keymap.set("n", "]d", function()
                    vim.diagnostic.jump({ count = 1, float = true })
                end, opts)
            end,
        })

        local capabilities = cmp_nvim_lsp.default_capabilities()
        if not capabilities.textDocument then
            capabilities.textDocument = {}
        end
        if not capabilities.textDocument.publishDiagnostics then
            capabilities.textDocument.publishDiagnostics = {}
        end

        capabilities.textDocument.publishDiagnostics.tagSupport = { valueSet = { 2 } }

        -- PYTHON PATH HELPER
        local function get_python_path(workspace)
            if workspace then
                local venv = workspace .. "/.venv/bin/python"
                if vim.fn.filereadable(venv) == 1 then
                    return venv
                end
            end
            if vim.fn.filereadable(".venv/bin/python") == 1 then
                return ".venv/bin/python"
            end
            return vim.fn.exepath("python3") or "python"
        end

        -- SERVER SETUP
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
                    })
                end,

                ["pyright"] = function()
                    lspconfig["pyright"].setup({
                        capabilities = capabilities,
                        settings = {
                            python = {
                                analysis = {
                                    autoSearchPaths = true,
                                    useLibraryCodeForTypes = true,
                                    diagnosticMode = "openFilesOnly",
                                },
                            },
                        },
                        on_new_config = function(new_config, new_root_dir)
                            new_config.settings.python.pythonPath = get_python_path(new_root_dir)
                        end,
                    })
                end,

                ["lua_ls"] = function()
                    lspconfig["lua_ls"].setup({
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                diagnostics = { disable = { "missing-fields" } },
                            },
                        },
                    })
                end,

                ["yamlls"] = function()
                    lspconfig["yamlls"].setup({
                        capabilities = capabilities,
                        settings = {
                            yaml = {
                                format = { enable = true },
                                validate = true,
                                completion = true,
                                schemaStore = {
                                    enable = false,
                                    url = "",
                                },
                                schemas = {
                                    ["https://raw.githubusercontent.com/awslabs/goformation/master/schema/cloudformation.schema.json"] = {
                                        "*.yaml",
                                        "*.yml",
                                        "*.template",
                                        "/*.yaml",
                                        "/*.yml",
                                    },
                                },
                                customTags = {
                                    "!And",
                                    "!Base64",
                                    "!Cidr",
                                    "!Equals",
                                    "!FindInMap",
                                    "!GetAtt",
                                    "!GetAZs",
                                    "!If",
                                    "!ImportValue",
                                    "!Join",
                                    "!Not",
                                    "!Or",
                                    "!Ref",
                                    "!Select",
                                    "!Split",
                                    "!Sub",
                                    "!fn",
                                },
                            },
                        },
                    })
                end,
            },
        })
    end,
}
