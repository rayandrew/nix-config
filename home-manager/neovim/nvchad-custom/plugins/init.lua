return {
  ["preservim/vimux"] = {},
  ["christoomey/vim-tmux-navigator"] = {},

  -- treesitter
  ["nvim-treesitter/nvim-treesitter-textobjects"] = {
    after = "nvim-treesitter",
  },
  ["mrjones2014/nvim-ts-rainbow"] = {
    after = "nvim-treesitter",
  },
  ["nvim-treesitter/nvim-treesitter-context"] = {
    after = "nvim-treesitter",
  },

  -- Git
  ["tpope/vim-fugitive"] = {},
  ["tpope/vim-rhubarb"] = {},
  ["lewis6991/gitsigns.nvim"] = {},

  -- Formatter
  ["jose-elias-alvarez/null-ls.nvim"] = {
    after = "nvim-lspconfig",
    requires = {
      "jayp0521/mason-null-ls.nvim",
    },
    config = function()
      require("custom.plugins.null-ls")
    end,
  },

  -- Github Copilot
  ["zbirenbaum/copilot.lua"] = {
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
  ["zbirenbaum/copilot-cmp"] = {
    after = { "copilot.lua" },
    config = function()
      require("copilot_cmp").setup()
    end,
  },

  -- others
  ["Pocco81/TrueZen.nvim"] = {},
  ["mg979/vim-visual-multi"] = {
    config = function()
      require("custom.plugins.visual-multi")
    end,
  },
  ["nathom/filetype.nvim"] = {
    config = function()
      require("custom.plugins.filetype")
    end,
  },
  ["akinsho/toggleterm.nvim"] = {
    tag = "*",
    config = function()
      require("toggleterm").setup({})
    end,
  },
  -- ["echasnovski/mini.surround"] = {
  --   -- tag = "*",
  --   config = function()
  --     require("mini.surround").setup({})
  --   end,
  -- },
  ["iamcco/markdown-preview.nvim"] = {
    run = "cd app && npm install",
    setup = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
  },
  ["ggandor/leap.nvim"] = {
    config = function()
      require("leap").add_default_mappings()
    end,
  },

  -- overrides
  ["neovim/nvim-lspconfig"] = {
    config = function()
      require("plugins.configs.lspconfig")
      require("custom.plugins.lspconfig")
    end,
  },

  ["williamboman/mason.nvim"] = {
    override_options = {
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
      },
    },
  },

  ["nvim-treesitter/nvim-treesitter"] = {
    override_options = {
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
    },
  },

  ["nvim-tree/nvim-tree.lua"] = {
    override_options = {
      git = {
        enable = true,
        ignore = true,
      },
    },
  },

  ["hrsh7th/nvim-cmp"] = {
    override_options = {
      sources = {
        { name = "luasnip" },
        { name = "copilot" },
        { name = "nvim_lsp" },
        { name = "buffer" },
        { name = "nvim_lua" },
        { name = "path" },
      },
    },
  },
}
