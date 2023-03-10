---@type ChadrcConfig
local M = {}

M.ui = {
  theme_toggle = {},
  theme = "gruvbox",
  transparency = false,

  changed_themes = {
    everforest = {
      base_30 = {
        darker_black = "#272f35",
        black = "#252e34", --  nvim bg
        black2 = "#323a40",
        one_bg = "#363e44",
        one_bg2 = "#363e44",
        one_bg3 = "#3a4248",
      },
    },
  },
}

M.plugins = "custom.plugins"
M.mappings = require("custom.mappings")

M.lazy_nvim = {
  lockfile = vim.fn.stdpath("data") .. "/lazy-lock.json",
}

return M
