return {
  { -- Mason: package manager for LSPs, formatters, linters, and DAPs
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  { -- Auto install LSPs when working on some code. Bridge the gap between mason and lspconfig
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        -- LSP
        "lua_ls", -- lua
        "ts_ls", -- typescript
        "cssls", -- css, scss, etc.
      },
    },
    config = function(_, opts)
      require("mason-lspconfig").setup(opts)
    end,
  },
  { -- Hook neovim to the LSPs (allows you to use the LSP)
    "neovim/nvim-lspconfig",
    dependencies = {
      "blink.cmp",
    },
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require("blink.cmp").get_lsp_capabilities()
      -- lspconfig.[lsp].setup({ capabilities = capabilities })
      lspconfig.lua_ls.setup({ capabilities = capabilities })

      local opts = { noremap = true, silent = true }
      local bufnr = vim.api.nvim_get_current_buf()
      local keymap = vim.api.nvim_buf_set_keymap
      keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
      keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
      keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
      keymap(bufnr, "n", "gI", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
      keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
      keymap(bufnr, "n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
      keymap(bufnr, "n", "<leader>lf", "<cmd>lua vim.lsp.buf.format{ async = true }<cr>", opts)
      keymap(bufnr, "n", "<leader>li", "<cmd>LspInfo<cr>", opts)
      keymap(bufnr, "n", "<leader>lI", "<cmd>LspInstallInfo<cr>", opts)
      keymap(bufnr, "n", "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
      keymap(bufnr, "n", "<leader>lj", "<cmd>lua vim.diagnostic.goto_next({buffer=0})<cr>", opts)
      keymap(bufnr, "n", "<leader>lk", "<cmd>lua vim.diagnostic.goto_prev({buffer=0})<cr>", opts)
      keymap(bufnr, "n", "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
      keymap(bufnr, "n", "<leader>ls", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
      keymap(bufnr, "n", "<leader>lq", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
    end,
  },
  { -- Allow you to ensure_install more than just LSPs (everything that mason has)
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = {
      "williamboman/mason.nvim",
    },
    opts = {
      ensure_installed = {
        -- Linter
        "eslint_d", -- web dev
        "stylelint", -- css, scss, etc.

        -- Formatter
        "stylua", --lua
        "prettierd", -- web dev
      },
      auto_update = true,
      run_on_start = true,
    },
    config = function(_, opts)
      require("mason-tool-installer").setup(opts)
    end,
  },
  { -- Used to add linting and formating into neovim. It is a generalized LSP that the other LSPs connect to to show to neovim
    "nvimtools/none-ls.nvim",
    dependencies = {
      "nvimtools/none-ls-extras.nvim",
    },
    config = function()
      local null_ls = require("null-ls")

      null_ls.setup({
        sources = {
          -- null_ls.builtins.formating.
          -- null_ls.builtins.diagnostics.
          -- null_ls.builtins.completion.
          null_ls.builtins.formatting.stylua,
          null_ls.builtins.formatting.prettierd,

          require("none-ls.diagnostics.eslint_d"), -- requires none-ls-extras.nvim
        },
      })

      vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
    end,
  },
}
