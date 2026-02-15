return {
  "MysticalDevil/inlay-hints.nvim",
  event = "LspAttach",
  dependencies = { "neovim/nvim-lspconfig" },
  config = function()
    require("inlay-hints").setup({
      ["rust_analyzer"] = {
        inlayHints = {
          parameter_hints = {
            show = true,
            prefix = "<- ",
            highlight = "Comment",
          },
          bindingModeHints = {
            enable = false,
          },
          chainingHints = {
            enable = true,
          },
          closingBraceHints = {
            enable = true,
            minLines = 25,
          },
          closureReturnTypeHints = {
            enable = "never",
          },
          lifetimeElisionHints = {
            enable = "never",
            useParameterNames = false,
          },
          maxLength = 25,
          parameterHints = {
            enable = true,
          },
          reborrowHints = {
            enable = "never",
          },
          renderColons = true,
          typeHints = {
            show = true,
            prefix = "=> ",
            highlight = "Comment",
          },
        },
      },
      ["tsserver"] = {
        typescript = {
          inlayHints = {
            includeInlayParameterNameHints = "all",
            includeInlayParameterNameHintsWhenArgumentMatchesName = true,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayVariableTypeHintsWhenTypeMatchesName = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
          },
        },
        ["javascript"] = {
          inlayHints = {
            includeInlayParameterNameHints = "all",
            includeInlayParameterNameHintsWhenArgumentMatchesName = true,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayVariableTypeHintsWhenTypeMatchesName = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
          },
        },
      },
    })

    -- Create ToggleInlayHints command
    local hints_enabled = true
    vim.api.nvim_create_user_command("ToggleInlayHints", function()
      hints_enabled = not hints_enabled
      vim.lsp.inlay_hint.enable(hints_enabled)
      if hints_enabled then
        print("Inlay hints enabled")
      else
        print("Inlay hints disabled")
      end
    end, { desc = "Toggle LSP inlay hints" })
  end,
}
