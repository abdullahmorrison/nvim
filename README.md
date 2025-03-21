# Abdullah's NeoVim Configuration

### Required
- c/c++ compiler (gcc/g++ for lsp)
- neovim
- ripgrep (for telescope)
- nodejs (for copilot)

### Installation
navigate to the plugins file and save the file to install all it's dependencies

## Mason Tools Addition Instruction
when working with a new language make sure the following is compelete in the lsp_config.lua
- add the lsp to ensured_install "williamboman/mason-lspconfig.nvim"
- call the setup function in the "neovim/nvim-lspconfig"
- add linter and formatter for that language in none-ls
- added sources to null_ls
