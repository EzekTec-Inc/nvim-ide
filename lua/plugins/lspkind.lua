return {
  "onsails/lspkind.nvim",
  event = "InsertEnter",
  config = function()
    require("lspkind").init({
      mode = "symbol_text",
      preset = "codicons",
    })
  end,
}
