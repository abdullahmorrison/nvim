local status_ok, ts_config = pcall(require, "nvim-treesitter.configs")
if not status_ok then
  return
end
ts_config.setup {
  -- A list of parser names, or "all" (the five listed parsers should always be installed)
  ensure_installed = { 
    "c", "lua", "vim", "vimdoc", "query", -- required for nvim
    "typescript", "javascript", "html", "css", -- web dev
    "cpp", -- general
  },
  auto_install = true,

  highlight = {
    enable = true,
  },
}
