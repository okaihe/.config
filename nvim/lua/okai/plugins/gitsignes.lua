return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    signs = {
      add          = { text = "┃" },
      change       = { text = "┃" },
      delete       = { text = "_" },
      topdelete    = { text = "‾" },
      changedelete = { text = "~" },
      untracked    = { text = "┆" },
    },
    current_line_blame = true,
    sign_priority = 11,
    current_line_blame_opts = {
      delay = 500,
    },

    on_attach = function(bufnr)
      local gs = require("gitsigns")
      local map = vim.keymap.set
      local opts = { buffer = bufnr, silent = true }
      map("n", "]c", function()
        if vim.wo.diff then return "]c" end
        vim.schedule(function() gs.next_hunk() end)
        return "<Ignore>"
      end, vim.tbl_extend("force", opts, { expr = true, desc = "Nächste Git-Änderung" }))

      map("n", "[c", function()
        if vim.wo.diff then return "[c" end
        vim.schedule(function() gs.prev_hunk() end)
        return "<Ignore>"
      end, vim.tbl_extend("force", opts, { expr = true, desc = "Vorherige Git-Änderung" }))
      map("n", "<leader>hp", gs.preview_hunk, vim.tbl_extend("force", opts, { desc = "Vorschau des Hunks" }))
      map("n", "<leader>hr", gs.reset_hunk, vim.tbl_extend("force", opts, { desc = "Änderung (Hunk) verwerfen" }))
      map("n", "<leader>hs", gs.stage_hunk, vim.tbl_extend("force", opts, { desc = "Änderung (Hunk) stagen" }))
    end,
  },
}
