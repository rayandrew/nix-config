vim.opt.rtp:prepend("{{ lazy-nvim }}")

vim.g.mapleader = " "
vim.o.background = "dark"

require("lazy").setup({
  { 
    dir = "{{ gruvbox-nvim }}",  
    lazy = false,
    priority = 1000,
    name = "gruvbox",
    config = function()
      vim.cmd([[colorscheme gruvbox]])
    end,
  },
  { 
    dir = "${vimPlugins.plenary-nvim}", 
    lazy = true,
  },
  {
    dir = "${vimPlugins.telescope-nvim}",
    cmd = "Telescope",
  }
}, {
  install = {
    colorscheme = { "gruvbox" },
  },
  -- load the default settings
  defaults = {
    autocmds = true, -- lazyvim.config.autocmds
    keymaps = true, -- lazyvim.config.keymaps
    options = true, -- lazyvim.config.options
  },
  performance = {
    cache = {
      enabled = true,
    },
    reset_packpath = true, -- reset the package path to improve startup time
    rtp = {
      reset = true,
    }
  },
  ui = {
    -- icons used by other plugins
    icons = {
      diagnostics = {
        Error = " ",
        Warn = " ",
        Hint = " ",
        Info = " ",
      },
      git = {
        added = " ",
        modified = " ",
        removed = " ",
      },
      kinds = {
        Array = " ",
        Boolean = " ",
        Class = " ",
        Color = " ",
        Constant = " ",
        Constructor = " ",
        Copilot = " ",
        Enum = " ",
        EnumMember = " ",
        Event = " ",
        Field = " ",
        File = " ",
        Folder = " ",
        Function = " ",
        Interface = " ",
        Key = " ",
        Keyword = " ",
        Method = " ",
        Module = " ",
        Namespace = " ",
        Null = " ",
        Number = " ",
        Object = " ",
        Operator = " ",
        Package = " ",
        Property = " ",
        Reference = " ",
        Snippet = " ",
        String = " ",
        Struct = " ",
        Text = " ",
        TypeParameter = " ",
        Unit = " ",
        Value = " ",
        Variable = " ",
      },
    },
  }
})

