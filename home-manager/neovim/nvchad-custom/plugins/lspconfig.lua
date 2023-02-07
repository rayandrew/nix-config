local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require("lspconfig")
local servers = {
  -- lua stuff
  "sumneko_lua",

  -- shell
  "bashls",
  -- "awk_ls",

  -- c
  "clangd",

  -- rust
  "rust_analyzer",

  -- web dev
  "cssls",
  "html",
  "tsserver",
  "jsonls",
  "tailwindcss",
  "eslint",

  -- python
  "pyright",

  -- yaml
  "yamlls",
}

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })
end
