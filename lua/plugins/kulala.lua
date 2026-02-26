return {
  "mistweaverco/kulala.nvim",
  ft = { "http", "rest" },
  keys = {
    { "<leader>rq", function()
      local ft = vim.bo.filetype
      local ext = vim.fn.expand("%:e")
      if ft == "http" or ft == "rest" or ext == "http" or ext == "rest" or ext == "https" then
        if ft ~= "http" and ft ~= "rest" then vim.bo.filetype = "http" end
        require("kulala").run()
      else
        vim.notify("Kulala only runs in .http, .https, or .rest files", vim.log.levels.WARN)
      end
    end, desc = "Run HTTP Request" },
    { "<leader>rt", function()
      local ft = vim.bo.filetype
      local ext = vim.fn.expand("%:e")
      if ft == "http" or ft == "rest" or ext == "http" or ext == "rest" or ext == "https" then
        if ft ~= "http" and ft ~= "rest" then vim.bo.filetype = "http" end
        require("kulala").toggle_view()
      else
        vim.notify("Kulala only runs in .http, .https, or .rest files", vim.log.levels.WARN)
      end
    end, desc = "Toggle Headers/Body View" },
  },
  config = function()
    require("kulala").setup()
  end,
}