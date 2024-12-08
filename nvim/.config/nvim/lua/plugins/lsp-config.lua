return {
	{    "williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"ruff_lsp",
					"ansiblels",
					"dockerls",
					"sqls",
					"terraformls"
				}
			})
		end
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local lspconfig = require("lspconfig")
			lspconfig.lua_ls.setup({})
			lspconfig.ruff_lsp.setup({})
			lspconfig.ruff.setup({})
			lspconfig.ansiblels.setup({})
			lspconfig.dockerls.setup({})
			lspconfig.sqls.setup({})
			lspconfig.terraformls.setup({})
			vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
			vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
			vim.keymap.set({ 'n' }, '<leader>ca', vim.lsp.buf.code_action, {})
		end
	}
}
