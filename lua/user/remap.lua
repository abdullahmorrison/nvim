local opts = { noremap = true, silent = true }

local term_opts = { silent = true }

-- Shorten function name
local keymap = vim.keymap.set

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

--Copilot
vim.g.copilot_no_tab_map = true
vim.g.copilot_assume_mapped = true
vim.api.nvim_set_keymap("i", "<C-J>", 'copilot#Accept("<CR>")', { silent = true, expr = true })

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

-- split windows
keymap("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

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
keymap("n", "<leader>ff", "<cmd>Telescope find_files<cr>", {desc = "Fuzzy find files"})
keymap("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", {desc = "Find string in cwd"})
keymap("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", {desc = "Find string under cursor in cwd"})

