return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local harpoon = require("harpoon")
        harpoon:setup()

        local keymap = vim.keymap.set

        -- 1. Mark file (Add)
        keymap("n", "<leader>a", function()
            harpoon:list():add()
        end, { desc = "Harpoon: Datei pinnen" })

        -- 2. Open menu (Quick Menu)
        keymap("n", "<leader>h", function()
            harpoon.ui:toggle_quick_menu(harpoon:list())
        end, { desc = "Harpoon: Menü öffnen" })

        -- 3. Navigate (Jump to files)
        keymap("n", "<leader>1", function()
            harpoon:list():select(1)
        end, { desc = "Harpoon: Gehe zu 1" })
        keymap("n", "<leader>2", function()
            harpoon:list():select(2)
        end, { desc = "Harpoon: Gehe zu 2" })
        keymap("n", "<leader>3", function()
            harpoon:list():select(3)
        end, { desc = "Harpoon: Gehe zu 3" })
        keymap("n", "<leader>4", function()
            harpoon:list():select(4)
        end, { desc = "Harpoon: Gehe zu 4" })

        -- Jump like buffer circle
        keymap("n", "<leader>hp", function()
            harpoon:list():prev()
        end, { desc = "Harpoon: Vorherige" })
        keymap("n", "<leader>hn", function()
            harpoon:list():next()
        end, { desc = "Harpoon: Nächste" })
    end,
}
