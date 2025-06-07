-- LSP
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
  signature = { enabled = true },

  -- Show documentation when selecting a completion item
  documentation = {
    auto_show = true,
    auto_show_delay_ms = 500,
  },
})

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    -- clear all predefined mappings, like 'K' for hover
    vim.cmd("mapclear <buffer>")
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    if client == nil then
      return
    end

    if client:supports_method('textDocument/inlayHint') then
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
    vim.keymap.set('n', '<Leader>lpe', function() vim.diagnostic.jump({ count = -1 }) end, opts)
    vim.keymap.set('n', '<Leader>lne', function() vim.diagnostic.jump({ count = 1 }) end, opts)
    vim.keymap.set('n', '<Leader>lq', vim.diagnostic.setloclist, opts)
  end,
})

vim.lsp.config('*', {
  capabilities = capabilities,
})

vim.lsp.config('clangd', {
  cmd = {
    'clangd',
    '--clang-tidy',
    '--background-index',
    '--offset-encoding=utf-8',
  },
  filetypes = { 'c', 'cpp', 'cc' },
  root_markers = {
    '.clangd',
    '.clang-tidy',
    '.clang-format',
    'compile_commands.json',
    'compile_flags.txt',
    'configure.ac',
    '.git',
  },
})

vim.lsp.config('hls', {
  cmd = { "haskell-language-server-wrapper", "--lsp" },
  filetypes = { 'haskell', 'lhaskell', 'cabal' },
  settings = {
    haskell = {
      plugin = {
        rename = { config = { crossModule = true } }
      }
    }
  },
  root_markers = { 'stack.yaml', 'cabal.project', '*.cabal', 'package.yaml', '.git' },
})

vim.lsp.config('lua_ls', {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_markers = { ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "stylua.toml", "selene.toml", "selene.yml", ".git" },
  on_init = function(client)
    if client.workspace_folders then
      local path = client.workspace_folders[1].name
      if
          path ~= vim.fn.stdpath('config')
          and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
      then
        return
      end
    end

    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
      runtime = {
        -- Tell the language server which version of Lua you're using (most
        -- likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Tell the language server how to find Lua modules same way as Neovim
        -- (see `:h lua-module-load`)
        path = {
          'lua/?.lua',
          'lua/?/init.lua',
        },
      },
      -- Make the server aware of Neovim runtime files
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME
          -- Depending on the usage, you might want to add additional paths
          -- here.
          -- '${3rd}/luv/library'
          -- '${3rd}/busted/library'
        }
        -- Or pull in all of 'runtimepath'.
        -- NOTE: this is a lot slower and will cause issues when working on
        -- your own configuration.
        -- See https://github.com/neovim/nvim-lspconfig/issues/3189
        -- library = {
        --   vim.api.nvim_get_runtime_file('', true),
        -- }
      }
    })
  end,
  settings = {
    Lua = {}
  }
})

vim.lsp.config('nixd', {
  cmd = { "nixd" },
  root_markers = { "flake.nix", "git" },
  filetypes = { "nix" },
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

vim.lsp.config('pyright', {
  cmd = { "pyright-langserver", "--stdio" },
  filetypes = { "python" },
  root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", "pyrightconfig.json", ".git" },
})

vim.lsp.config('rust_analyzer', {
  cmd = { "rust-analyzer" },
  filetypes = { "rust" },
  root_markers = { "Cargo.toml", ".git" },
  settings = {
    ['rust-analyzer'] = {
      diagnostics = {
        enable = false,
      }
    }
  }
})

vim.lsp.enable({ 'clangd', 'hls', 'lua_ls', 'nixd', 'pyright', 'rust_analyzer' })
