vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4
vim.opt_local.expandtab = true

local jdtls_ok, jdtls = pcall(require, "jdtls")
if not jdtls_ok then
    vim.notify("JDTLS not found, install with `:LspInstall jdtls`")
    return
end

-- ============================================================================
-- 1. Pfade dynamisch ermitteln (Wichtig für Updates & Portabilität)
-- ============================================================================
local home = os.getenv("HOME")
local mason_path = home .. "/.local/share/nvim/mason"
local jdtls_path = mason_path .. "/packages/jdtls"

-- Findet die Launcher-JAR automatisch, egal welche Version gerade installiert ist
local launcher_jar = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")

-- Ermittelt das richtige Config-Verzeichnis für Mac oder Linux
local config_path = jdtls_path .. "/config_mac"
if vim.fn.has("mac") == 0 then
    config_path = jdtls_path .. "/config_linux"
end

local lombok_path = jdtls_path .. "/lombok.jar"

-- Workspace-Verzeichnis (Pro Projekt ein eigener Ordner)
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = home .. "/.local/share/nvim/java/jdtls/" .. project_name
if vim.fn.isdirectory(workspace_dir) == 0 then
    os.execute("mkdir -p " .. workspace_dir)
end

-- ============================================================================
-- 2. On Attach (Keymaps & Setup)
-- ============================================================================
local on_attach = function(client, bufnr)
    -- Das hier lädt extra Befehle wie "Organize Imports"
    jdtls.setup_dap({ hotcodereplace = "auto" })

    local opts = { noremap = true, silent = true, buffer = bufnr }
    local keymap = vim.keymap.set

    -- Standard LSP Navigation
    keymap("n", "gd", vim.lsp.buf.definition, opts) -- Springe zur Definition
    keymap("n", "K", vim.lsp.buf.hover, opts) -- Doku anzeigen
    keymap("n", "<leader>rn", vim.lsp.buf.rename, opts) -- Umbenennen
    keymap("n", "<leader>ca", vim.lsp.buf.code_action, opts) -- Code Actions (Imports fixen etc.)

    -- Navigation mit Telescope
    keymap("n", "gr", "<cmd>Telescope lsp_references<CR>", opts)

    -- Java Spezifisch
    keymap(
        "n",
        "<leader>oi",
        "<cmd>lua require('jdtls').organize_imports()<CR>",
        { desc = "Java: Organize Imports", buffer = bufnr }
    )
    keymap(
        "n",
        "<leader>tc",
        "<cmd>lua require('jdtls').test_class()<CR>",
        { desc = "Java: Test Class", buffer = bufnr }
    )
    keymap(
        "n",
        "<leader>tm",
        "<cmd>lua require('jdtls').test_nearest_method()<CR>",
        { desc = "Java: Test Method", buffer = bufnr }
    )
end

-- ============================================================================
-- 3. Die Konfiguration
-- ============================================================================
local config = {
    cmd = {
        "java",
        "-Declipse.application=org.eclipse.jdt.ls.core.id1",
        "-Dosgi.bundles.defaultStartLevel=4",
        "-Declipse.product=org.eclipse.jdt.ls.core.product",
        "-Dlog.protocol=true",
        "-Dlog.level=ALL",
        "-javaagent:" .. lombok_path,
        "-Xms1g",
        "--add-modules=ALL-SYSTEM",
        "--add-opens",
        "java.base/java.util=ALL-UNNAMED",
        "--add-opens",
        "java.base/java.lang=ALL-UNNAMED",

        "-jar",
        launcher_jar,
        "-configuration",
        config_path,
        "-data",
        workspace_dir,
    },

    -- Root Verzeichnis finden (pom.xml, .git, etc.)
    root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }),

    -- Einstellungen für den Server
    settings = {
        java = {
            home = "/opt/homebrew/Cellar/openjdk@17/17.0.9/libexec/openjdk.jdk/Contents/Home", -- PFAD GGF PRÜFEN!
            eclipse = { downloadSources = true },
            maven = { downloadSources = true },
            implementationsCodeLens = { enabled = true },
            referencesCodeLens = { enabled = true },
            references = { includeDecompiledSources = true },
            signatureHelp = { enabled = true },
            sources = {
                organizeImports = {
                    starThreshold = 9999,
                    staticStarThreshold = 9999,
                },
            },
        },
    },

    -- Initialisierung
    init_options = {
        bundles = {},
    },

    -- Keymaps binden
    on_attach = on_attach,
}

-- STARTEN
require("jdtls").start_or_attach(config)
