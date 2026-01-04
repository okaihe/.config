return {
    "tpope/vim-fugitive",
    config = function()
        vim.keymap.set("n", "<leader>gs", vim.cmd.Git, { desc = "Git Status" })
        vim.keymap.set("n", "<leader>gc", ":Git commit<CR>", { desc = "Git Commit" })
        vim.keymap.set("n", "<leader>gp", ":Git push<CR>", { desc = "Git Push" })
        vim.keymap.set("n", "<leader>gh", ":diffget //2<CR>", { desc = "Diffget links (target)" })
        vim.keymap.set("n", "<leader>gl", ":diffget //3<CR>", { desc = "Diffget rechts (merge)" })
    end,
}
