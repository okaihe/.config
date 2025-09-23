return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        { "antosha417/nvim-lsp-file-operations", config = true },
    },
    config = function()
        local cmp_nvim_lsp = require("cmp_nvim_lsp")
        local keymap = vim.keymap
        local opts = { noremap = true, silent = true }

        -- Funktion, um automatisch den .venv Interpreter zu finden
        local function get_python_path()
            local venv = vim.fn.getcwd() .. "/.venv/bin/python"
            if vim.fn.filereadable(venv) == 1 then
                return venv
            else
                return "/usr/bin/python3" -- Fallback
            end
        end

        local on_attach = function(client, bufnr)
            client.server_capabilities.semanticTokensProvider = nil
            opts.buffer = bufnr

            opts.desc = "Show LSP references"
            keymap.set("n", "<leader>gr", "<cmd>Telescope lsp_references<CR>", opts)
            opts.desc = "Go to declaration"
            keymap.set("n", "<leader>gD", vim.lsp.buf.declaration, opts)
            opts.desc = "Show LSP definitions"
            keymap.set("n", "<leader>gd", "<cmd>Telescope lsp_definitions<CR>", opts)
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
            keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
            opts.desc = "Go to next diagnostic"
            keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
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

        vim.lsp.enable("html")
        vim.lsp.config("html", { capabilities = capabilities, on_attach = on_attach })

        vim.lsp.enable("pyright")
        vim.lsp.config("pyright", {
            capabilities = capabilities,
            on_attach = on_attach,
            settings = {
                python = {
                    pythonPath = get_python_path(),
                },
            },
        })

        vim.lsp.enable("dockerls")
        vim.lsp.config("dockerls", { capabilities = capabilities, on_attach = on_attach })

        vim.lsp.enable("tsls")
        vim.lsp.config("ts_ls", { capabilities = capabilities, on_attach = on_attach })

        vim.lsp.enable("gopls")
        vim.lsp.config("gopls", { capabilities = capabilities, on_attach = on_attach })

        vim.lsp.enable("cssls")
        vim.lsp.config("cssls", { capabilities = capabilities, on_attach = on_attach })

        vim.lsp.enable("yamlls")
        vim.lsp.config("yamlls", {
            capabilities = capabilities,
            on_attach = on_attach,
            settings = {
                yaml = {
                    schemas = {
                        ["https://raw.githubusercontent.com/awslabs/goformation/master/schema/cloudformation.json"] = "*.template",
                    },
                    customTags = {
                        "!Ref",
                        "!ImportValue",
                        "!Sub",
                        "!Join",
                        "!GetAtt",
                        "!FindInMap",
                        "!Equals",
                        "!And",
                        "!Or",
                        "!Not",
                        "!If",
                    },
                    validate = true,
                },
            },
        })

        vim.lsp.enable("gitlab_ci_ls")
        vim.lsp.config("gitlab_ci_ls", {
            capabilities = capabilities,
            on_attach = on_attach,
            filetypes = { "yaml.gitlab" },
        })

        vim.lsp.enable("emmet_ls")
        vim.lsp.config("emmet_ls", {
            capabilities = capabilities,
            on_attach = on_attach,
            filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
        })

        local languageServerPath = "/opt/homebrew/lib/node_modules/@angular/language-server/"
        vim.lsp.enable("angularls")
        vim.lsp.config("angularls", {
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

        vim.lsp.enable("phpactor")
        vim.lsp.config("phpactor", { capabilities = capabilities, on_attach = on_attach })

        vim.lsp.enable("jdtls")
        vim.lsp.config("jdtls", {
            capabilities = capabilities,
            on_attach = on_attach,
            root_dir = vim.fs.root(0, { "pom.xml", "build.gradle", ".git" }) or vim.fn.getcwd(),
        })

        vim.lsp.enable("rust_analyzer")
        vim.lsp.config("rust_analyzer", {
            capabilities = capabilities,
            on_attach = on_attach,
            settings = {
                ["rust-analyzer"] = {
                    assist = { importEnforceGranularity = true, importPrefix = "crate" },
                    cargo = { allFeatures = true },
                    diagnostics = { enable = true, experimental = { enable = true } },
                },
            },
        })

        vim.lsp.enable("lua_ls")
        vim.lsp.config("lua_ls", {
            capabilities = capabilities,
            on_attach = on_attach,
            settings = {
                Lua = {
                    diagnostics = { globals = { "vim" } },
                    workspace = {
                        library = {
                            [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                            [vim.fn.stdpath("config") .. "/lua"] = true,
                        },
                    },
                },
            },
        })

        vim.lsp.enable("texlab")
        vim.lsp.config("texlab", { capabilities = capabilities, on_attach = on_attach })
    end,
}
