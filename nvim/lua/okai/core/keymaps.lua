local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Resize with arrows
keymap("n", "<M-Up>", ":resize +2<CR>", opts)
keymap("n", "<M-Down>", ":resize -2<CR>", opts)
keymap("n", "<M-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<M-Right>", ":vertical resize +2<CR>", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- Move text up and down
keymap("n", "<A-j>", "<Esc>:m .+1<CR>==gi", opts)
keymap("n", "<A-k>", "<Esc>:m .-2<CR>==gi", opts)

-- Wrapped lines
keymap("n", "j", "gj", opts)
keymap("n", "k", "gk", opts)
keymap("n", "0", "g0", opts)
keymap("n", "$", "g$", opts)

-- Close Buffer
keymap("n", "<leader>bc", ":bp|bd #<CR>", opts)
keymap("n", "<leader>bw", ":bw!<CR>", opts)

-- Cursor position while traversing search
keymap("n", "n", "nzzzv", opts)

-- Cursor position while moving page wise
keymap("n", "<C-d>", "<C-d>zz", opts)
keymap("n", "<C-u>", "<C-u>zz", opts)

-- Cursor position while J
keymap("n", "J", "mzJ`z", opts)

-- Delete search
keymap("n", "<esc>", ":noh<return><esc>", opts)

--
local function runcmd()
    vim.cmd("silent! wa!")
    local cmdinput = vim.o.makeprg
    cmdinput = cmdinput:gsub(" ", "\\ ")
    vim.cmd("set splitbelow")
    local runcommand = "split +term\\ " .. cmdinput
    vim.cmd(runcommand)
end
vim.cmd(":set makeprg=python3\\ %")
vim.keymap.set("n", "<leader>mp", runcmd)

-- Löschen ohne den Text ins Register zu kopieren (Void Register)
keymap("n", "<leader>d", [["_d]], opts)
keymap("v", "<leader>d", [["_d]], opts)

-- Insert --
-- Move one character or line
keymap("i", "<A-h>", "<C-o>h", opts)
keymap("i", "<A-l>", "<C-o>l", opts)
keymap("i", "<A-j>", "<C-o>j", opts)
keymap("i", "<A-k>", "<C-o>k", opts)

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move text up and down
keymap("v", "<A-j>", ":m .+1<CR>==", opts)
keymap("v", "<A-k>", ":m .-2<CR>==", opts)
keymap("v", "p", '"_dP', opts)

-- Visual Block --
-- Move text up and down
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

-- Better escape from terminal
-- keymap("t", "<esc>", "<C-\\><C-N>", opts)

-- Better copy from/to systems clipboard
keymap("v", "<leader>y", '"*y', opts)
keymap("n", "<leader>p", '"*p', opts)
