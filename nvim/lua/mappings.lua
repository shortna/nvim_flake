local g = vim.g
-- telescope man pages sections
local builtin = require('telescope.builtin')

g.mapleader = " "
vim.keymap.set('n', '<Leader>ve', '<Cmd>Ex<CR>', { silent = true })
vim.keymap.set('n', '<Tab>', '<Cmd>bnext<CR>', { silent = true })
vim.keymap.set('n', '<S-Tab>', '<Cmd>bprevious<CR>', { silent = true })
vim.keymap.set('n', '<Leader>vbl', '<Cmd>ls<CR>', { silent = true })
vim.keymap.set('t', '<S-Tab>', '<C-\\><C-n>', { nowait = true })

vim.keymap.set('n', '<leader>tgs', builtin.grep_string, { desc = 'Grep string under cursor' })
vim.keymap.set('n', '<leader>tgl', builtin.live_grep, { desc = 'Grep' })
vim.keymap.set('n', '<leader>tff', builtin.find_files, { desc = 'Find file' })
vim.keymap.set('n', '<leader>tfb', builtin.buffers, { desc = 'Find buffer' })
vim.keymap.set('n', '<leader>ut', vim.cmd.UndotreeToggle)
