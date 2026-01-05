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

        -- 1. DIAGNOSTIK CONFIG (Icons etc.)
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

        -- 2. ZENTRALE KEYMAP DEFINITION (Der Fix!)
        -- Dieser Block wird JEDES MAL ausgeführt, wenn sich IRGENDEIN LSP verbindet.
        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
            callback = function(ev)
                -- Hilfsfunktion für Buffer-lokale Mappings
                local opts = { buffer = ev.buf, silent = true }
                local keymap = vim.keymap

                -- Debugging: Falls du unsicher bist, ob das hier läuft,
                -- entkommentiere die nächste Zeile und schau ob beim Öffnen "LSP Connected" erscheint.
                -- print("LSP Connected to buffer " .. ev.buf)

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

                -- Navigation durch Fehler
                keymap.set("n", "[d", function()
                    vim.diagnostic.jump({ count = -1, float = true })
                end, opts)
                keymap.set("n", "]d", function()
                    vim.diagnostic.jump({ count = 1, float = true })
                end, opts)
            end,
        })

        -- 3. CAPABILITIES
        local capabilities = cmp_nvim_lsp.default_capabilities()

        -- SICHERHEITS-CHECK: Wir erstellen die Tabellenstruktur, falls sie fehlt
        if not capabilities.textDocument then
            capabilities.textDocument = {}
        end
        if not capabilities.textDocument.publishDiagnostics then
            capabilities.textDocument.publishDiagnostics = {}
        end

        -- Jetzt können wir den Wert sicher setzen (hilft Pyright, ungenutzte Variablen grau zu markieren)
        capabilities.textDocument.publishDiagnostics.tagSupport = { valueSet = { 2 } }

        -- 4. PYTHON PATH HELPER
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

        -- 5. SERVER SETUP
        mason_lspconfig.setup({
            ensure_installed = { "pyright", "html", "lua_ls" }, -- deine Liste hier
            handlers = {
                -- Standard Handler für alle Server
                function(server_name)
                    lspconfig[server_name].setup({
                        capabilities = capabilities,
                        -- WICHTIG: Hier KEIN 'on_attach' mehr übergeben!
                        -- Das macht jetzt der Autocommand oben automatisch.
                    })
                end,

                -- Spezifischer Handler für Pyright
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

                -- Lua LS Config (gekürzt)
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
            },
        })
    end,
}
