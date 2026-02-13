pcall(function()
  if vim.g.base46_cache and type(vim.g.base46_cache) == "string" then
    dofile(vim.g.base46_cache .. "syntax")
    dofile(vim.g.base46_cache .. "treesitter")
  end
end)

local options = {
  ensure_installed = { "lua", "luadoc", "printf", "vim", "vimdoc" },

  highlight = {
    enable = true,
    use_languagetree = true,
  },

  indent = { enable = true },
}

return options
