---@type ChadrcConfig
local M = {}

-- local highlights = require "custom.highlights"

M.ui = {
  theme_toggle = { "tokyodark", "one_light" },
  theme = "tokyodark",
  -- theme_toggle = { "ayu-dark", "one_light" },
  -- theme = "ayu-dark",
  -- hl_override = highlights.override,
  -- hl_add = highlights.add,
  transparency = false,
}

M.plugins = require("custom.plugins")
M.mappings = require("custom.mappings")

return M
