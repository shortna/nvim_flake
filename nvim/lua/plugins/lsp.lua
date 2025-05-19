-- LSP
local lspconfig = require('lspconfig')
local blink = require('blink.cmp')
local capabilities = blink.get_lsp_capabilities()
blink.setup({
	-- 'default' for mappings similar to built-in completion
	-- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
	-- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
	-- see the "default configuration" section below for full documentation on how to define
	-- your own keymap.
	keymap = { preset = 'default' },

	appearance = {
		-- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
		-- Adjusts spacing to ensure icons are aligned
		nerd_font_variant = 'mono'
	},

	-- default list of enabled providers defined so that you can extend it
	-- elsewhere in your config, without redefining it, via `opts_extend`
	sources = { default = { 'lsp', 'path', 'snippets', 'buffer' } },

	-- experimental auto-brackets support
	-- completion = { accept = { auto_brackets = { enabled = true } } }
	signature = { enabled = true }
})

vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(args)
		-- clear all predefined mappings, like 'K' for hover
		vim.cmd("mapclear <buffer>")
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client == nil then
			return
		end

		if client.supports_method('textDocument/inlayHint') then
			vim.lsp.inlay_hint.enable(true);
		end

		-- Mappings.
		local opts = { buffer = args.buf, noremap = true, silent = true }
		vim.keymap.set({ 'n', 'v' }, '<Leader>lf', function() vim.lsp.buf.format({ async = true }) end, opts)
		vim.keymap.set('n', '<Leader>lD', vim.lsp.buf.declaration, opts)
		vim.keymap.set('n', '<Leader>ld', vim.lsp.buf.definition, opts)
		vim.keymap.set('n', '<Leader>lh', vim.lsp.buf.hover, opts)
		vim.keymap.set('n', '<Leader>ls', vim.lsp.buf.signature_help, opts)
		vim.keymap.set('n', '<Leader>lca', vim.lsp.buf.code_action, opts)
		vim.keymap.set('n', '<Leader>lrn', vim.lsp.buf.rename, opts)
		vim.keymap.set('n', '<Leader>lr', vim.lsp.buf.references, opts)
		vim.keymap.set('n', '<Leader>le', vim.diagnostic.open_float, opts)
		vim.keymap.set('n', '<Leader>lpe', vim.diagnostic.goto_prev, opts)
		vim.keymap.set('n', '<Leader>lne', vim.diagnostic.goto_next, opts)
		vim.keymap.set('n', '<Leader>lq', vim.diagnostic.setloclist, opts)
	end,
})

lspconfig.rust_analyzer.setup({
	capabilities = capabilities
})
lspconfig.clangd.setup({
	capabilities = capabilities
})
lspconfig.lua_ls.setup({
	capabilities = capabilities,
	cmd = { "lua-language-server" },
	on_init = function(client)
		if client.workspace_folders then
			local path = client.workspace_folders[1].name
			if vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc') then
				return
			end
		end

		client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
			runtime = {
				version = 'LuaJIT'
			},
			workspace = {
				checkThirdParty = false,
				library = {
					vim.env.VIMRUNTIME
				}
			}
		})
	end,
	settings = {
		Lua = {}
	},
})
lspconfig.hls.setup({
	capabilities = capabilities,
	filetypes = { 'haskell', 'lhaskell', 'cabal' },
	cmd = { "haskell-language-server-wrapper", "--lsp" },
	settings = {
		haskell = {
			plugin = {
				rename = { config = { crossModule = true } }
			}
		}
	}
})
lspconfig.nixd.setup({
	capabilities = capabilities,
	cmd = { "nixd" },
	settings = {
		nixd = {
			nixpkgs = {
				expr = "import <nixpkgs> { }",
			},
			formatting = {
				command = { "nixfmt" },
			},
		},
	},
})
lspconfig.pyright.setup({
	capabilities = capabilities
})
