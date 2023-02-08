-- vim.cmd([[
-- let g:VM_Mono_hl   = 'Substitute'
-- let g:VM_Cursor_hl = 'IncSearch'
-- ]])

vim.g.VM_Mono_hl = "Substitute"
vim.g.VM_Cursor_hl = "IncSearch"

vim.g.VM_maps = {
  ["Find Under"] = "<C-d>",
  ["Find Subword Under"] = "<C-d>",
  ["Next"] = "n",
  ["Previous"] = "N",
  ["Skip"] = "q",
  -- ["Add Cursor Down"] = "<C-j>",
  -- ["Add Cursor Up"] = "<C-k>",
  -- ["Select l"] = "<S-Left>",
  -- ["Select r"] = "<S-Right>",
  -- ["Add Cursor at Position"] = [[\\\]],
  ["Select All"] = "<C-c>",
  ["Visual All"] = "<C-c>",
  ["Exit"] = "<Esc>",
}
