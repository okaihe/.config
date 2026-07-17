return {
  "tpope/vim-fugitive",
  config = function()
    local map = vim.keymap.set
    map("n", "<leader>gs", vim.cmd.Git, { desc = "Git Status (Fugitive)" })
  end,
}
