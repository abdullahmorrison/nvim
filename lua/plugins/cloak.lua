-- hide env variable values (env=******)
return {
  "laytan/cloak.nvim",
  config = function()
    vim.keymap.set("n", "<leader>c", ":CloakToggle<CR>")
  end,
}
