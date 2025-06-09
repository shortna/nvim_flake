require('telescope').setup({
  defaults = {
    border = false,
  }
})

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function(args)
    local normal = vim.api.nvim_get_hl(0, { name = "Normal" })
    vim.api.nvim_set_hl(0, "TelescopeNormal", { fg = normal.fg, bg = normal.bg })
    vim.api.nvim_set_hl(0, "TelescopePromptNormal", { fg = normal.fg, bg = normal.bg })

    local prefix = vim.api.nvim_get_hl(0, { name = "TelescopePromptPrefix" })
    vim.api.nvim_set_hl(0, "TelescopePromptPrefix", { fg = prefix.fg, bg = normal.bg })
  end
})
