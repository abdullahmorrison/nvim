return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  opts = {
    sync_install = false,
    auto_install = true,
    highlight = { enable = true },
    indent = { enable = true },
  },
}
