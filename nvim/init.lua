local g = vim.g
local opt = vim.opt

-- basic stuff
opt.syntax = "enable"
opt.number = true
opt.relativenumber = true

opt.colorcolumn = "0"
opt.wrap = false
opt.cursorline = true
opt.cursorlineopt = "both"
opt.mouse = ""
opt.hlsearch = true
opt.incsearch = true
opt.swapfile = false
opt.hidden = true
opt.termguicolors = true
opt.wrapscan = false

-- fold stuff
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldenable = false
opt.foldlevel = 99

-- indent stuff
opt.expandtab = false
opt.tabstop = 8
opt.shiftwidth = 2
opt.softtabstop = 2

-- menu stuff
opt.wildmenu = true
opt.wildmode = 'full'

-- do not let quckifix to spawn where it wants
opt.switchbuf = "useopen"

-- remove numbers in terminal
vim.api.nvim_create_autocmd('TermOpen', {
  callback = function()
    opt.relativenumber = false
    opt.number = false
  end
})
-- vim doesnt like compound literals
g.c_no_curly_error = true

-- presistent undo
opt.undofile = true

-- lua is enough
g.loaded_node_provider = 0
g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0
g.loaded_python3_provider = 0

-- line
g.airline_symbols_ascii = 1
g.airline_section_z = ""

vim.cmd("colorscheme base16-catppuccin-latte")
