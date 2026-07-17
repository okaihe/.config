-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local map = vim.keymap.set
local opts = { silent = true }

-- Exit search with escape
map("n", "<Esc>", "<cmd>nohlsearch<CR>", opts)

-- Indentation in visual mode
map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)

-- Copy/Paste with System Clipboard
map({ "n", "v" }, "<leader>y", '"+y', opts)
map({ "n", "v" }, "<leader>p", '"+p', opts)

-- Window navigation
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

