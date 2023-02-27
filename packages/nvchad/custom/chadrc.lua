---@type ChadrcConfig
local M = {}

M.ui = {
  theme_toggle = {},
  -- theme = "one_light",
  theme = "ayu-light",
  transparency = false,
}

M.plugins = "custom.plugins"
M.mappings = require("custom.mappings")

M.lazy_nvim = {
  lockfile = vim.fn.stdpath("data") .. "/lazy-lock.json",
}

return M
