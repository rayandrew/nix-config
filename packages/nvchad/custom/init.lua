local autocmd = vim.api.nvim_create_autocmd

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  command = ":%s/s+$//e",
})

-- remove trailing whitespace
local remove_spaces_group = vim.api.nvim_create_augroup("RemoveSpaces", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  command = ":%s/s+$//e",
  group = remove_spaces_group,
})

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = "*",
})

-- Options

-- Relative number
vim.wo.relativenumber = true
vim.opt.relativenumber = true

-- Notify me for line length
vim.opt.colorcolumn = "80"

-- Cursor
vim.opt.guicursor = ""
