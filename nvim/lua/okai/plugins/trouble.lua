return {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
        focus = true, -- WICHTIG: Wenn du die Liste öffnest, springt der Cursor direkt rein
        indent_lines = false, -- Macht die Liste cleaner

        -- Hier definieren wir, wie sich das Fenster verhält
        modes = {
            diagnostics = {
                mode = "diagnostics", -- inherit from diagnostics mode
                preview = {
                    type = "split", -- Zeigt eine Vorschau des Codes direkt in Trouble an
                    relative = "win",
                    position = "right",
                    size = 0.3,
                },
            },
        },
    },
    keys = {
        -- 1. Das Wichtigste: Alle Fehler im PROJEKT anzeigen
        -- Perfekt für Rust/Angular Refactorings ("Wo ist jetzt alles rot?")
        {
            "<leader>xx",
            "<cmd>Trouble diagnostics toggle<cr>",
            desc = "Diagnostics (Project)",
        },

        -- 2. Nur Fehler in der AKTUELLEN DATEI
        -- Wenn du dich nur auf eine Komponente fokussieren willst
        {
            "<leader>xX",
            "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
            desc = "Diagnostics (Current Buffer)",
        },

        -- 3. Symbole (Klassen, Funktionen) in der Datei übersichtlich sehen
        -- Ersatz für Outline-Plugins
        {
            "<leader>xs",
            "<cmd>Trouble symbols toggle focus=false<cr>",
            desc = "Symbols (Trouble)",
        },

        -- 4. Quickfix Integration
        -- Wenn du z.B. ':make' ausführst oder grep benutzt
        {
            "<leader>xq",
            "<cmd>Trouble qflist toggle<cr>",
            desc = "Quickfix List (Trouble)",
        },

        -- 5. LSP Referenzen (Alternative zu Telescope)
        -- Zeigt alle Stellen, wo eine Funktion benutzt wird
        {
            "<leader>xr",
            "<cmd>Trouble lsp_references toggle<cr>",
            desc = "LSP References (Trouble)",
        },
    },
}
