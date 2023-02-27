return {
  { "preservim/vimux" },
  { "christoomey/vim-tmux-navigator" },
  { "JoosepAlviste/nvim-ts-context-commentstring" },
  { "nvim-treesitter/nvim-treesitter-textobjects" },
  { "mrjones2014/nvim-ts-rainbow" },
  { "nvim-treesitter/nvim-treesitter-context" },

  {
    "glepnir/lspsaga.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
  },

  -- Copilot
  {
    "zbirenbaum/copilot.lua",
    event = "VimEnter",
    config = function()
      vim.defer_fn(function()
        require("copilot").setup({
          suggestion = {
            keymap = {
              accept = "<c-g>",
              accept_word = false,
              accept_line = false,
              next = "<c-j>",
              prev = "<c-k>",
              dismiss = "<c-f>",
            },
            -- auto_trigger = true,
          },
        })
      end, 100)
    end,
  },
  {
    "zbirenbaum/copilot-cmp",
    event = "VeryLazy",
    dependencies = { "zbirenbaum/copilot.lua" },
    config = function()
      require("copilot_cmp").setup()
    end,
  },

  -- Git
  { "tpope/vim-fugitive" },
  { "tpope/vim-rhubarb" },
  { "lewis6991/gitsigns.nvim" },

  -- Others
  {
    "Pocco81/TrueZen.nvim",
    cmd = { "TZNarrow", "TZFocus", "TZMinimalist", "TZAtaraxis" },
    config = true,
  },
  {
    "nathom/filetype.nvim",
    opts = function()
      return {
        overrides = {
          extensions = {
            mdx = "markdown",
          },
          function_complex = {
            [".*blade.php"] = function()
              vim.bo.filetype = "blade"
            end,
          },
        },
      }
    end,
  },
  {
    "mg979/vim-visual-multi",
    keys = "<C-d>",
    -- lazy = true,
    config = function(_, _)
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
    end,
  },
  {
    "akinsho/toggleterm.nvim",
    event = "VeryLazy",
    cmd = { "ToggleTerm" },
    version = "*",
    config = true,
    --opts = function()
    --  require("toggleterm").setup()
    --end,
  },
  {
    "tpope/vim-surround",
    dependencies = {
      "tpope/vim-repeat",
    },
  },
  {
    "iamcco/markdown-preview.nvim",
    build = "cd app && npm install",
    config = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
  },
  {
    "ggandor/leap.nvim",
    config = function()
      require("leap").add_default_mappings()
    end,
  },

  -- LSPs
  {
    "neovim/nvim-lspconfig",
    config = function(_, _)
      require("plugins.configs.lspconfig")
      local on_attach = require("plugins.configs.lspconfig").on_attach
      local capabilities = require("plugins.configs.lspconfig").capabilities

      local lspconfig = require("lspconfig")
      local servers = {
        -- lua stuff
        "lua_ls",

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
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "neovim/nvim-lspconfig",
      "mason.nvim",
    },
    opts = function()
      -- null-ls
      -- to setup format on save
      local null_ls = require("null-ls")

      local formatting = null_ls.builtins.formatting -- to setup formatters
      local diagnostics = null_ls.builtins.diagnostics -- to setup linters
      local code_actions = null_ls.builtins.code_actions -- to setup code actions
      local completion = null_ls.builtins.completion -- to setup completions

      local lsp_formatting_group = vim.api.nvim_create_augroup("LspFormatting", {})

      -- configure null_ls
      return {
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

          -- config
          formatting.taplo,
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
      }
    end,
  },

  {
    "williamboman/mason.nvim",
    opts = function()
      return {
        ensure_installed = {
          -- lua stuff
          "lua-language-server",
          "stylua",

          -- shell
          "bash-language-server",
          -- "awk-language-server",
          "shfmt",
          "shellcheck",

          -- c
          "clangd",

          -- rust
          "rust-analyzer",
          "rustfmt",

          -- web dev
          "css-lsp",
          "html-lsp",
          "typescript-language-server",
          "json-lsp",
          "tailwindcss-language-server",
          "eslint-lsp",

          -- python
          "pyright",

          -- yaml
          "yaml-language-server",

          -- toml
          "taplo",
        },
      }
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function()
      return vim.tbl_deep_extend("force", require("plugins.configs.treesitter"), {
        ensure_installed = {
          "c",
          "cpp",
          "css",
          "go",
          "lua",
          "python",
          "rust",
          "typescript",
          "svelte",
          "html",
          "java",
          "help",
          "nix",
        },
      })
    end,
  },
}
