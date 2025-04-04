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
      lspconfig.ts_ls.setup({ capabilities = capabilities })
      lspconfig.cssls.setup({ capabilities = capabilities })

      vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", {desc = "Show hover"})
      vim.keymap.set("n", "<leader>gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", {desc = "Go to declaration"})
      vim.keymap.set("n", "<leader>gd", "<cmd>lua vim.lsp.buf.definition()<CR>", {desc = "Go to definition"})
      vim.keymap.set("n", "<leader>gI", "<cmd>lua vim.lsp.buf.implementation()<CR>", {desc = "Go to implementation"})
      vim.keymap.set("n", "<leader>gr", "<cmd>lua vim.lsp.buf.references()<CR>", {desc = "Show references"})
      vim.keymap.set("n", "<leader>gl", "<cmd>lua vim.diagnostic.open_float()<CR>", {desc = "Show diagnostics"})
      vim.keymap.set("n", "<leader>lf", "<cmd>lua vim.lsp.buf.format()<CR>", {desc = "Format"})
      vim.keymap.set("n", "<leader>li", "<cmd>LspInfo<CR>", {desc = "Show LSP info"})
      vim.keymap.set("n", "<leader>lI", "<cmd>LspInstallInfo<CR>", {desc = "Show LSP install info"})
      vim.keymap.set("n", "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<CR>", {desc = "Show code actions"})
      vim.keymap.set("n", "<leader>lj", "<cmd>lua vim.diagnostic.goto_next({buffer=0})<CR>", {desc = "Go to next diagnostic"})
      vim.keymap.set("n", "<leader>lk", "<cmd>lua vim.diagnostic.goto_prev({buffer=0})<CR>", {desc = "Go to previous diagnostic"})
      vim.keymap.set("n", "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<CR>", {desc = "Rename"})
      vim.keymap.set("n", "<leader>ls", "<cmd>lua vim.lsp.buf.signature_help()<CR>", {desc = "Show signature help"})
      vim.keymap.set("n", "<leader>lq", "<cmd>lua vim.diagnostic.setloclist()<CR>", {desc = "Show diagnostics in loclist"})
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
		end,
	},
}
