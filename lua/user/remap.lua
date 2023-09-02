vim.g.mapleader = " "

-- Shorten function name
local keymap = vim.keymap.set

keymap("n", "<leader>e", vim.cmd.Ex)

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv^", opts)
keymap("v", ">", ">gv^", opts)

keymap("v", "p", '"_dP', opts) -- yank holds the same value after pasting over some text
