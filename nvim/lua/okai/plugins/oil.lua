return {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        require("oil").setup({
            default_file_explorer = true,
            columns = {
                "icon",
                "permissions",
                "size",
                "mtime",
            },
            view_options = {
                show_hidden = false,
            },
            skip_confirm_for_simple_edits = true,
            watch_for_changes = true,
            keymaps = {
                ["g?"] = "actions.show_help",
                ["<CR>"] = "actions.select",
                ["<C-v>"] = "actions.select_vsplit", -- In vertikalem Split öffnen
                ["<C-h>"] = "actions.select_split", -- In horizontalem Split öffnen
                ["<C-c>"] = "actions.close", -- Oil schließen
                ["-"] = "actions.parent",    -- Einen Ordner nach oben gehen
                ["g."] = "actions.toggle_hidden", -- Versteckte Dateien ein-/ausblenden
            },
        })
        vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Öffne das übergeordnete Verzeichnis" })
    end,
}
