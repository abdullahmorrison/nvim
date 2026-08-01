-- Asserts that this config's stated intent actually took effect.
--
-- Most nvim misconfigurations are silent. An option nested one level too deep, a
-- spec key the plugin loader ignores, a `master`-branch option handed to a
-- `main`-branch plugin -- none of these raise an error, so the config reads
-- correctly and does nothing. Reviewing the diff cannot catch that; only running
-- it can.
--
-- Each check below pins one such intent. When you fix a silent bug, add the
-- assertion that proves the fix took effect.
--
-- Run: nvim --headless -c 'luafile tests/config_spec.lua' -c 'qa!'

local passed, failures = 0, {}

local function check(name, fn)
  local ok, err = pcall(fn)
  if ok then
    passed = passed + 1
    io.write("  ok    " .. name .. "\n")
  else
    table.insert(failures, name)
    io.write("  FAIL  " .. name .. "\n          " .. tostring(err):gsub("\n", "\n          ") .. "\n")
  end
end

local function eq(actual, expected, what)
  if actual ~= expected then
    error(("%s: expected %s, got %s"):format(what, vim.inspect(expected), vim.inspect(actual)), 0)
  end
end

local function mapped(mode, lhs)
  local map = vim.fn.maparg(lhs, mode, false, true)
  if not map or vim.tbl_isempty(map) then
    error(("no %s-mode mapping for %s"):format(mode, lhs), 0)
  end
  return map
end

-- lazy.nvim loads most plugins on demand, and a headless session fires a
-- different set of events than an interactive one. Force-load anything under
-- test so results don't depend on which autocmds happened to run.
local function load(...)
  require("lazy").load({ plugins = { ... } })
end

io.write("\nplugin manager\n")

check("lazy.nvim is loaded", function()
  eq(package.loaded["lazy"] ~= nil, true, "lazy loaded")
end)

check("no plugin spec errors", function()
  local notifs = require("lazy.core.config").spec.notifs or {}
  local errors = {}
  for _, n in ipairs(notifs) do
    if n.level == vim.log.levels.ERROR then
      table.insert(errors, n.msg)
    end
  end
  if #errors > 0 then
    error(table.concat(errors, "\n"), 0)
  end
end)

check("every plugin in lazy-lock.json is in the resolved spec", function()
  local lock = vim.fn.json_decode(table.concat(vim.fn.readfile("lazy-lock.json"), "\n"))
  local plugins = require("lazy.core.config").plugins
  local missing = {}
  for name in pairs(lock) do
    if name ~= "lazy.nvim" and not plugins[name] then
      table.insert(missing, name)
    end
  end
  if #missing > 0 then
    error("locked but not in spec: " .. table.concat(missing, ", "), 0)
  end
end)

-- Guards against a half-finished install being mistaken for a healthy one.
-- lazy's async pipeline can be cut short (a quit that outruns it, an
-- interrupted sync), leaving plugins cloned but not checked out or built. The
-- config still boots in that state, so nothing else here would notice.
check("every locked plugin is installed at its locked commit", function()
  local lock = vim.fn.json_decode(table.concat(vim.fn.readfile("lazy-lock.json"), "\n"))
  local root = require("lazy.core.config").options.root
  local bad = {}
  for name, entry in pairs(lock) do
    -- lazy.nvim bootstraps itself from the `stable` branch, so its checkout is
    -- not expected to match the lockfile.
    if name ~= "lazy.nvim" then
      local dir = root .. "/" .. name
      if vim.fn.isdirectory(dir) == 0 then
        table.insert(bad, name .. ": not installed")
      else
        local head = vim.trim(vim.fn.system({ "git", "-C", dir, "rev-parse", "HEAD" }))
        if head ~= entry.commit then
          table.insert(bad, ("%s: at %s, lockfile says %s"):format(name, head:sub(1, 8), entry.commit:sub(1, 8)))
        end
      end
    end
  end
  if #bad > 0 then
    error(table.concat(bad, "\n"), 0)
  end
end)

check("plugins with build steps produced their artifacts", function()
  local root = require("lazy.core.config").options.root
  -- markdown-preview.nvim builds its browser frontend via yarn. Skip the build
  -- and :MarkdownPreview opens a tab that never connects to anything.
  if vim.fn.isdirectory(root .. "/markdown-preview.nvim/app/node_modules") == 0 then
    error("markdown-preview.nvim: app/node_modules missing, its build step never ran", 0)
  end
end)

io.write("\ncore settings\n")

check("leader is space", function()
  eq(vim.g.mapleader, " ", "mapleader")
end)

check("colorscheme is tokyodark", function()
  eq(vim.g.colors_name, "tokyodark", "colors_name")
end)

check("indentation is 2 spaces", function()
  eq(vim.o.expandtab, true, "expandtab")
  eq(vim.o.shiftwidth, 2, "shiftwidth")
  eq(vim.o.tabstop, 2, "tabstop")
end)

check("persistent undo is on", function()
  eq(vim.o.undofile, true, "undofile")
end)

check("system clipboard is shared", function()
  eq(vim.o.clipboard, "unnamedplus", "clipboard")
end)

check("relative line numbers are on", function()
  eq(vim.o.number, true, "number")
  eq(vim.o.relativenumber, true, "relativenumber")
end)

io.write("\nkeymaps\n")

check("telescope pickers are mapped", function()
  load("telescope.nvim")
  mapped("n", "<leader>ff")
  mapped("n", "<leader>fg")
  mapped("n", "<leader>fc")
end)

check("file explorer is mapped", function()
  load("neo-tree.nvim")
  mapped("n", "<leader>e")
end)

check("harpoon add and menu are mapped", function()
  load("harpoon")
  mapped("n", "<leader>a")
  mapped("n", "<C-e>")
end)

check("undotree toggle is mapped", function()
  load("undotree")
  mapped("n", "<leader><F5>")
end)

check("cloak toggle is mapped", function()
  load("cloak.nvim")
  mapped("n", "<leader>c")
end)

check("lsp actions are mapped", function()
  load("nvim-lspconfig")
  mapped("n", "K")
  mapped("n", "<leader>gd")
  mapped("n", "<leader>lf")
  mapped("n", "<leader>la")
  mapped("n", "<leader>lr")
end)

check("window navigation is owned by vim-tmux-navigator", function()
  -- config/remap.lua also binds <C-h/j/k/l>, but vim-tmux-navigator loads
  -- afterwards and overrides it. This asserts the behaviour that actually wins,
  -- so that seamless tmux/nvim pane movement can't regress unnoticed.
  load("vim-tmux-navigator")
  local rhs = mapped("n", "<C-h>").rhs or ""
  if not rhs:match("TmuxNavigateLeft") then
    error("<C-h> resolves to " .. vim.inspect(rhs) .. ", expected TmuxNavigateLeft", 0)
  end
end)

io.write("\nlsp\n")

check("expected language servers are configured", function()
  load("nvim-lspconfig")
  for _, server in ipairs({ "lua_ls", "ts_ls", "cssls" }) do
    local cfg = vim.lsp.config[server]
    if not cfg then
      error("no vim.lsp.config entry for " .. server, 0)
    end
  end
end)

check("lua_ls knows about the vim global", function()
  load("nvim-lspconfig")
  local globals = vim.tbl_get(vim.lsp.config, "lua_ls", "settings", "Lua", "diagnostics", "globals") or {}
  if not vim.tbl_contains(globals, "vim") then
    error("lua_ls diagnostics.globals is " .. vim.inspect(globals) .. ", expected it to contain 'vim'", 0)
  end
end)

io.write(("\n%d passed, %d failed\n"):format(passed, #failures))

if #failures > 0 then
  io.write("\nfailing checks:\n")
  for _, name in ipairs(failures) do
    io.write("  - " .. name .. "\n")
  end
  vim.cmd("cquit 1")
end
