local theme = {
  theme = "dropdown",
  border = true,
  borderchars = {
        prompt =  { "═", "║", "",  "║", "╔", "╗", "",  "" },
        results = { " ", "║", "═", "║", "║", "║", "╝", "╚" },
        preview = { "═", "║", "═", "║", "╔", "╗", "╝", "╚" },
  }
}

require('telescope').setup({
  defaults = {
    border = true,
  },
  pickers = {
    find_files = theme,
    grep_string = theme,
    live_grep = theme,
    buffers = theme,
  },
})

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function(args)
    local normal = vim.api.nvim_get_hl(0, { name = "Normal" })
    vim.api.nvim_set_hl(0, "TelescopeNormal", { fg = normal.fg, bg = normal.bg })
    vim.api.nvim_set_hl(0, "TelescopePromptNormal", { fg = normal.fg, bg = normal.bg })

    vim.api.nvim_set_hl(0, "TelescopeBorder", { fg = normal.fg, bg = normal.bg })
    vim.api.nvim_set_hl(0, "TelescopePromptBorder", { fg = normal.fg, bg = normal.bg })
    vim.api.nvim_set_hl(0, "TelescopeResultsTitle", { fg = normal.fg, bg = normal.bg })

    local prefix = vim.api.nvim_get_hl(0, { name = "TelescopePromptPrefix" })
    vim.api.nvim_set_hl(0, "TelescopePromptPrefix", { fg = prefix.fg, bg = normal.bg })
  end
})
