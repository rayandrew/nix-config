-- mason null ls
local mason_null_ls_status, mason_null_ls = pcall(require, "mason-null-ls")

if mason_null_ls_status then
  mason_null_ls.setup({
    automatic_installation = true,
    ensure_installed = {
      -- lua
      "stylua",

      -- c / c++
      "clang-format",

      -- shell
      "jq",
      "shfmt",

      -- web stuffs
      "prettier",
      "eslint_d",

      -- config
      "yamlfmt",

      -- python
      "black",

      -- rust
      "rustfmt",

      -- nix
      "nixpkgs_fmt",
      -- "nixfmt",
    },
  })
end

-- null-ls
-- to setup format on save
local null_ls = require("null-ls")

local formatting = null_ls.builtins.formatting -- to setup formatters
local diagnostics = null_ls.builtins.diagnostics -- to setup linters
local code_actions = null_ls.builtins.code_actions -- to setup code actions
local completion = null_ls.builtins.completion -- to setup completions

local lsp_formatting_group = vim.api.nvim_create_augroup("LspFormatting", {})

-- configure null_ls
null_ls.setup({
  debug = false,
  -- setup formatters & linters
  sources = {
    completion.spell,
    code_actions.gitsigns,

    -- lua
    formatting.stylua,

    -- web stuffs
    formatting.prettier.with({
      extra_filetypes = { "svelte" },
    }), -- js/ts formatter
    diagnostics.eslint_d.with({ -- js/ts linter
      -- only enable eslint if root has .eslintrc.js (not in youtube nvim video)
      condition = function(utils)
        return utils.root_has_file(".eslintrc.js") or utils.root_has_file(".eslintrc.cjs") -- change file extension if you use something else
      end,
      filetypes = {
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "vue",
        "svelte",
      },
    }),
    code_actions.eslint_d.with({
      filetypes = {
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "vue",
        "svelte",
      },
    }),

    -- php
    diagnostics.php,
    formatting.blade_formatter,
    -- formatting.pint,

    -- python
    formatting.black,

    -- shell
    formatting.shfmt,
    formatting.jq,

    -- rust
    formatting.rustfmt,

    -- c / c++
    formatting.clang_format,

    -- nix
    formatting.nixpkgs_fmt,
    -- formatting.nixfmt,
  },
  -- configure format on save
  on_attach = function(current_client, bufnr)
    if current_client.supports_method("textDocument/formatting") then
      vim.api.nvim_clear_autocmds({ group = lsp_formatting_group, buffer = bufnr })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = lsp_formatting_group,
        buffer = bufnr,
        callback = function()
          -- print("HERE 1", current_client.name)
          -- vim.lsp.buf.formatting_sync()
          vim.lsp.buf.format({
            bufnr = bufnr,
            filter = function(client)
              -- print("HERE 2", current_client.name, client.name)
              --  only use null-ls for formatting instead of lsp server
              return client.name == "null-ls"
            end,
          })
        end,
      })
    end
  end,
})
