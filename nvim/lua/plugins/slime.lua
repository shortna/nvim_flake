local g = vim.g
g.slime_target = "neovim"
g.slime_haskell_ghci_add_let = 0
g.slime_no_mappings = 1

vim.keymap.set('x', '<leader>rps', "<Plug>SlimeRegionSend")
vim.keymap.set('n', '<leader>rpl', "<Plug>SlimeLineSend")
