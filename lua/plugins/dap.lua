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
      local codelldb_path = vim.fn.stdpath("data") .. '/mason/bin/codelldb'
      
      dap.adapters.codelldb = function(on_config)
        if vim.fn.executable(codelldb_path) == 1 then
          on_config({
            type = 'server',
            port = "${port}",
            executable = {
              command = codelldb_path,
              args = {"--port", "${port}"},
            }
          })
        else
          vim.notify("codelldb not found. Install it with :MasonInstall codelldb", vim.log.levels.WARN)
        end
      end

      dap.configurations.rust = {
        {
          name = "Launch file",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/target/debug/', 'file')
          end,
          cwd = vim.fn.getcwd(),
          stopOnEntry = false,
        },
      }
      dap.configurations.c = dap.configurations.rust
      dap.configurations.cpp = dap.configurations.rust

      -- 2. Python (debugpy)
      dap.adapters.python = {
        type = 'executable',
        command = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python",
        args = { '-m', 'debugpy.adapter' },
      }

      dap.configurations.python = {
        {
          type = 'python',
          request = 'launch',
          name = "Launch file",
          program = "${file}",
          pythonPath = function()
            return vim.env.VIRTUAL_ENV and (vim.env.VIRTUAL_ENV .. "/bin/python") or 'python3'
          end,
        },
      }

      -- 3. JS/TS (pwa-node) - requires js-debug-adapter
      local js_debug_path = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js"
      dap.adapters["pwa-node"] = function(on_config)
        if vim.fn.filereadable(js_debug_path) == 1 then
          on_config({
            type = "server",
            host = "localhost",
            port = "${port}",
            executable = {
              command = "node",
              args = { js_debug_path, "${port}" },
            }
          })
        else
          vim.notify("js-debug-adapter not found. Install it with :MasonInstall js-debug-adapter", vim.log.levels.WARN)
        end
      end

      for _, language in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact" }) do
        dap.configurations[language] = {
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch file",
            program = "${file}",
            cwd = vim.fn.getcwd(),
          },
        }
      end

      -- Signs configuration
      vim.fn.sign_define('DapBreakpoint', {text='󰏃', texthl='DapBreakpoint', linehl='', numhl=''})
      vim.fn.sign_define('DapStopped', {text='󰁕', texthl='DapStopped', linehl='Visual', numhl=''})
    end,
  }
}
