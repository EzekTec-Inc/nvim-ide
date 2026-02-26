return {
  'nvimdev/lspsaga.nvim',
  event = "LspAttach",
  config = function()
    require('lspsaga').setup {
      ui = {
        border = 'rounded',
        -- Fix code action menu rendering artifacts (powerline triangles with mismatched colors)
        button = { '', '' },
      },
      code_action = {
        -- Prevent code action UI from conflicting with gitsigns column
        extend_gitsigns = false,
      },
      lightbulb = {
        enable = false, -- disabled: uses deprecated client.supports_method (removed in Nvim 0.13)
      },
      symbol_in_winbar = {
        enable = false, -- disabled: uses deprecated client.request/supports_method (removed in Nvim 0.13)
      },
    }

    -- error lens
    if vim.fn.has("nvim-0.11") == 1 then
      vim.diagnostic.config({
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = '',
            [vim.diagnostic.severity.WARN] = '',
            [vim.diagnostic.severity.INFO] = '',
            [vim.diagnostic.severity.HINT] = '',
          },
          linehl = {
            [vim.diagnostic.severity.ERROR] = 'ErrorLine',
            [vim.diagnostic.severity.WARN] = 'WarningLine',
            [vim.diagnostic.severity.INFO] = 'InfoLine',
            [vim.diagnostic.severity.HINT] = 'HintLine',
          },
        },
      })
    else
      vim.fn.sign_define {
        {
          name = 'DiagnosticSignError',
          text = '',
          texthl = 'DiagnosticSignError',
          linehl = 'ErrorLine',
        },
        {
          name = 'DiagnosticSignWarn',
          text = '',
          texthl = 'DiagnosticSignWarn',
          linehl = 'WarningLine',
        },
        {
          name = 'DiagnosticSignInfo',
          text = '',
          texthl = 'DiagnosticSignInfo',
          linehl = 'InfoLine',
        },
        {
          name = 'DiagnosticSignHint',
          text = '',
          texthl = 'DiagnosticSignHint',
          linehl = 'HintLine',
        },
      }
    end
  end,
}
