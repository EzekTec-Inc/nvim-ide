-- Text toggler for alternating values
-- Ported from nvim-jan-2026-working.bak
return {
  "rmagatti/alternate-toggler",
  event = "VeryLazy",
  config = function()
    require("alternate-toggler").setup {
      alternates = {
        ["Vec::new();"] = "vec!",
        ["enum"] = "struct",
        ["struct"] = "enum",
        ["const"] = "let",
        ["let"] = "const",
        ["true"] = "false",
        ["True"] = "False",
        ["TRUE"] = "FALSE",
        ["Yes"] = "No",
        ["YES"] = "NO",
        ["on"] = "off",
        ["ON"] = "OFF",
        ["1"] = "0",
        ["<"] = ">",
        ["("] = ")",
        ["["] = "]",
        ["{"] = "}",
        ['"'] = "'",
        ['""'] = "''",
        ["+"] = "-",
        ["="] = "==",
        ["!="] = "==",
        ["==="] = "!==",
        ["=="] = "!=",
        ["NOTE:"] = "FIXME:",
        ["error"] = "warn",
      },
    }
  end,
}
