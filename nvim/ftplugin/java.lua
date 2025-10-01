-- ~/.config/nvim/ftplugin/java.lua
vim.cmd([[ setlocal tabstop=4 shiftwidth=4 expandtab ]])

local ok, jdtls = pcall(require, "jdtls")
if not ok then
    vim.notify("nvim-jdtls not installed")
    return
end

local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
local root_dir = require("jdtls.setup").find_root(root_markers)
if not root_dir then
    vim.notify("Kein Projekt-Root gefunden")
    return
end

-- Workspace-Verzeichnis pro Projekt
local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
local workspace_dir = vim.fn.stdpath("data") .. "/java/jdtls/" .. project_name
if vim.fn.isdirectory(workspace_dir) == 0 then
    vim.fn.mkdir(workspace_dir, "p")
end

-- Pfade zu JDTLS & Lombok
local jdtls_path = vim.fn.stdpath("data") .. "/mason/packages/jdtls"
local lombok_jar = jdtls_path .. "/lombok.jar"
local jdtls_path = vim.fn.stdpath("data") .. "/mason/packages/jdtls"
local launcher_jar = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")
local config_dir = jdtls_path .. "/config_mac" -- macOS, passe an wenn nötig

-- LSP Konfiguration
local config = {
    cmd = {
        "java",
        "-Declipse.application=org.eclipse.jdt.ls.core.id1",
        "-Dosgi.bundles.defaultStartLevel=4",
        "-Declipse.product=org.eclipse.jdt.ls.core.product",
        "-javaagent:" .. lombok_jar,
        "-Xms1g",
        "--add-modules=ALL-SYSTEM",
        "--add-opens",
        "java.base/java.util=ALL-UNNAMED",
        "--add-opens",
        "java.base/java.lang=ALL-UNNAMED",
        "-jar",
        launcher_jar,
        "-configuration",
        config_dir,
        "-data",
        workspace_dir,
    },
    root_dir = root_dir,
    settings = {
        java = {
            home = "/opt/homebrew/Cellar/openjdk@17/17.0.9/libexec/openjdk.jdk/Contents/Home",
            eclipse = { downloadSources = true },
            maven = { downloadSources = true },
            referencesCodeLens = { enabled = true },
            implementationsCodeLens = { enabled = true },
            references = { includeDecompiledSources = true },
        },
        signatureHelp = { enabled = true },
        completion = {
            favoriteStaticMembers = {
                "org.hamcrest.MatcherAssert.assertThat",
                "org.hamcrest.Matchers.*",
                "org.hamcrest.CoreMatchers.*",
                "org.junit.jupiter.api.Assertions.*",
                "java.util.Objects.requireNonNull",
                "java.util.Objects.requireNonNullElse",
                "org.mockito.Mockito.*",
            },
        },
        sources = { organizeImports = { starThreshold = 9999, staticStarThreshold = 9999 } },
        codeGeneration = {
            toString = { template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}" },
            useBlocks = true,
        },
    },
    init_options = {
        bundles = {},
    },
}

-- Start oder attach
jdtls.start_or_attach(config)
