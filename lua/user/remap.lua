local opts = { noremap = true, silent = true }

local term_opts = { silent = true }

-- Shorten function name
local keymap = vim.keymap.set

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Shorten function name
local keymap = vim.keymap.set

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",
--
-- Normal --
-- don't yank with x
keymap("n", "x", '"_x')

-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Resize with arrows
keymap("n", "<C-Up>", ":resize +5<CR>", opts)
keymap("n", "<C-Down>", ":resize 1<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize 1<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +5<CR>", opts)

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv^", opts)
keymap("v", ">", ">gv^", opts)

keymap("v", "p", '"_dP', opts) -- yank holds the same value after pasting over some text

-- explorer to the left
keymap("n", "<leader>e", ":NvimTreeToggle <cr>", opts)

-- Telescope
keymap("n", "<leader>ff", ":Telescope find_files<cr>")
keymap("n", "<leader>fg", ":Telescope live_grep<cr>")
