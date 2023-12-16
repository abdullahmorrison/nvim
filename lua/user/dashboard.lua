local status_ok, dashboard = pcall(require, "dashboard");
if not status_ok then
  vim.notify("Missing dashboard dependency: dashboard", vim.log.levels.ERROR);
end

dashboard.setup{
  theme = 'hyper', --  theme is doom and hyper default is hyper
  disable_move = false,    --  default is false disable move keymap for hyper
  shortcut_type = 'letter',   --  shorcut type 'letter' or 'number
  change_to_vcs_root = false, -- default is false,for open file in hyper mru. it will change to the root of vcs
  config = {
    week_header = {
     enable = true,
    },
    shortcut = {
      { desc = '󰊳 Update', group = '@property', action = 'PackerUpdate', key = 'u' },
      {
        icon = ' ',
        icon_hl = '@variable',
        desc = 'Files',
        group = 'Label',
        action = 'Telescope find_files',
        key = 'f',
      },
      -- {
      --   desc = ' Apps',
      --   group = 'DiagnosticHint',
      --   action = 'Telescope app',
      --   key = 'a',
      -- },
      -- {
      --   desc = ' dotfiles',
      --   group = 'Number',
      --   action = 'Telescope dotfiles',
      --   key = 'd',
      -- },
    },
  },
  hide = {
    statusline = false,    -- hide statusline default is true
    tabline = false,       -- hide the tabline
    winbar = false,        -- hide winbar
  },
  -- preview = {
  --   command = true,       -- preview command
  --   file_path = true,     -- preview file path
  --   file_height = true,   -- preview file height
  --   file_width = true    -- preview file width
  -- },
}

