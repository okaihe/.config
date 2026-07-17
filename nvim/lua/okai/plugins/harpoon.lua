return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local harpoon = require("harpoon")

    harpoon:setup({
      settings = {
        save_on_toggle = true,
        sync_on_ui_close = true,
      },
      menu = {
        width = vim.api.nvim_win_get_width(0) - 40,
      },
    })

    local map = vim.keymap.set
    local opts = { silent = true }

    map("n", "<leader>ha", function()
      harpoon:list():add()
    end, vim.tbl_extend("force", opts, { desc = "Harpoon: Datei hinzufügen" }))

    map("n", "<leader>he", function()
      harpoon.ui:toggle_quick_menu(harpoon:list(), { border = "none" })
    end, vim.tbl_extend("force", opts, { desc = "Harpoon: Menü öffnen" }))

    map("n", "<leader>h1", function() harpoon:list():select(1) end, vim.tbl_extend("force", opts, { desc = "Harpoon: Slot 1" }))
    map("n", "<leader>h2", function() harpoon:list():select(2) end, vim.tbl_extend("force", opts, { desc = "Harpoon: Slot 2" }))
    map("n", "<leader>h3", function() harpoon:list():select(3) end, vim.tbl_extend("force", opts, { desc = "Harpoon: Slot 3" }))
    map("n", "<leader>h4", function() harpoon:list():select(4) end, vim.tbl_extend("force", opts, { desc = "Harpoon: Slot 4" }))

    map("n", "<leader>hn", function() harpoon:list():next() end, vim.tbl_extend("force", opts, { desc = "Harpoon: Nächste Datei" }))
    map("n", "<leader>hp", function() harpoon:list():prev() end, vim.tbl_extend("force", opts, { desc = "Harpoon: Vorherige Datei" }))
  end,
}
