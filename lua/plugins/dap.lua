return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-neotest/nvim-nio",
      "williamboman/mason.nvim",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      dapui.setup()
      require("nvim-dap-virtual-text").setup({})

      -- Automatically open/close DAP UI
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      -- Adapters configuration
      
      -- 1. Rust / C++ (codelldb)
      dap.adapters.codelldb = {
        type = 'server',
        port = "${port}",
        executable = {
          command = vim.fn.stdpath("data") .. '/mason/bin/codelldb',
          args = {"--port", "${port}"},
        }
      }

      dap.configurations.rust = {
        {
          name = "Launch file",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/target/debug/', 'file')
          end,
          cwd = '${workspaceRoot}',
          stopOnEntry = false,
        },
      }
      dap.configurations.c = dap.configurations.rust
      dap.configurations.cpp = dap.configurations.rust

      -- 2. Python (debugpy)
      dap.adapters.python = function(cb, config)
        if config.request == 'launch' then
          local port = 5678
          local host = '127.0.0.1'
          cb({
            type = 'server',
            port = port,
            host = host,
            executable = {
              command = vim.fn.stdpath("data") .. '/mason/bin/debugpy-adapter',
            }
          })
        end
      end

      dap.configurations.python = {
        {
          type = 'python',
          request = 'launch',
          name = "Launch file",
          program = "${file}",
          pythonPath = function()
            return 'python3'
          end,
        },
      }

      -- 3. JS/TS (pwa-node) - requires chrome-debug-adapter or js-debug-adapter
      -- Note: This is a basic setup, often improved with nvim-dap-vscode-js
      dap.adapters["pwa-node"] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = "node",
          args = { vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js", "${port}" },
        }
      }

      for _, language in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact" }) do
        dap.configurations[language] = {
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch file",
            program = "${file}",
            cwd = "${workspaceRoot}",
          },
        }
      end

      -- Signs configuration
      vim.fn.sign_define('DapBreakpoint', {text='󰏃', texthl='DapBreakpoint', linehl='', numhl=''})
      vim.fn.sign_define('DapStopped', {text='󰁕', texthl='DapStopped', linehl='Visual', numhl=''})
    end,
  }
}
