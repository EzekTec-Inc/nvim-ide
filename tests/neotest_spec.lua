local assert = require("luassert")

describe("neotest configuration", function()
  it("loads neotest and has rust and python adapters", function()
    local ok, neotest = pcall(require, "neotest")
    assert.is_true(ok, "Failed to load neotest")

    local adapters = neotest.state.adapter_ids()
    local has_rust = false
    local has_python = false

    for _, adapter in ipairs(adapters) do
      if string.match(adapter, "rust") then has_rust = true end
      if string.match(adapter, "python") then has_python = true end
    end

    assert.is_true(has_rust, "Missing Rust adapter")
    assert.is_true(has_python, "Missing Python adapter")
  end)
end)
