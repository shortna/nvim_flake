-- LSP
local cmp = require('cmp')
local lspconfig = require('lspconfig')

-- nvim-cmp setup
cmp.setup({ snippet = {
    expand = function(args)
      vim.snippet.expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<CR>'] = cmp.mapping.confirm({ select = false })
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'path' },
    { name = 'buffer' },
  }),
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

lspconfig.rust_analyzer.setup{}
lspconfig.clangd.setup({ })
lspconfig.lua_ls.setup({
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
  filetypes = { 'haskell', 'lhaskell', 'cabal' },
  cmd = { "haskell-language-server-wrapper", "--lsp" },
  settings = {
    haskell = {
      plugin = {
        rename = { config = { crossModule = true }}
      }
    }
  }
})
lspconfig.nixd.setup({
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
lspconfig.pyright.setup({})
lspconfig.csharp_ls.setup({})
