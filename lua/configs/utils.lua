local M = {}

-- Global map function wrapper
M.glb_map = vim.keymap.set

-- FIX 2026-02-13T23:47:40: ft_to_lang shim is now simplified and defined in init.lua

-- Go to GitHub link generated from string under cursor
M.go_to_github_link = function()
  local word = vim.fn.expand("<cWORD>")
  
  -- Check if it looks like a GitHub repo reference (user/repo or org/repo)
  local repo_pattern = "([%w%-_%.]+/[%w%-_%.]+)"
  local match = word:match(repo_pattern)
  
  if match then
    local url = "https://github.com/" .. match
    -- Remove trailing punctuation if any
    url = url:gsub("[,;:%.%?!]+$", "")
    
    -- Open URL based on OS
    local cmd
    if vim.fn.has("mac") == 1 then
      cmd = "open"
    elseif vim.fn.has("unix") == 1 then
      cmd = "xdg-open"
    elseif vim.fn.has("win32") == 1 then
      cmd = "start"
    end
    
    if cmd then
      vim.fn.jobstart({ cmd, url }, { detach = true })
      print("Opening: " .. url)
    else
      print("Could not determine how to open URL")
    end
  else
    -- Try to find a URL in the current word
    local url_pattern = "https?://[%w%-_%.%?%&%=%/%#]+"
    local url = word:match(url_pattern)
    
    if url then
      local cmd
      if vim.fn.has("mac") == 1 then
        cmd = "open"
      elseif vim.fn.has("unix") == 1 then
        cmd = "xdg-open"
      elseif vim.fn.has("win32") == 1 then
        cmd = "start"
      end
      
      if cmd then
        vim.fn.jobstart({ cmd, url }, { detach = true })
        print("Opening: " .. url)
      end
    else
      print("No GitHub repo or URL found under cursor")
    end
  end
end

return M
