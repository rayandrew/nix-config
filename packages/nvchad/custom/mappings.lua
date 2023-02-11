---@type MappingsConfig
local M = {}

M.general = {
  n = {
    [";"] = { ":", "enter command mode", opts = { nowait = true } },
  },
}

M.file = {
  n = {
    -- file / directory
    ["<leader>fF"] = {
      function()
        require("telescope.builtin").find_files({ cwd = vim.fn.expand("%:p:h") })
      end,
      "[F]ind [F]iles in current directory",
    },
    ["<leader>fo"] = {
      function()
        require("telescope.builtin").oldfiles()
      end,
      "[F]ind recently [o]pened files",
    },
    ["<leader>fs"] = { "<cmd> :w <CR>", "[F]ile [S]ave" },
    ["<leader>fw"] = { function() end, "Nothing" },
  },
}

M.search = {
  n = {
    -- search
    ["<leader>sd"] = {
      function()
        require("telescope.builtin").diagnostics()
      end,
      "[S]earch [D]iagnostics",
    },
    ["<leader>sf"] = {
      function()
        require("telescope.builtin").find_files()
      end,
      "[S]earch [F]iles",
    },
    ["<leader>sh"] = {
      function()
        require("telescope.builtin").help_tags()
      end,
      "[S]earch [H]elp",
    },
    ["<leader>sw"] = {
      function()
        require("telescope.builtin").grep_string()
      end,
      "[S]earch current [W]ord",
    },
    ["<leader>sp"] = {
      function()
        require("telescope.builtin").live_grep()
      end,
      "[S]earch by gre[p]",
    },
    ["<leader>sg"] = {
      function()
        require("telescope.builtin").live_grep()
      end,
      "[S]earch by [g]rep",
    },
    ["<leader>so"] = {
      function()
        require("telescope.builtin").oldfiles()
      end,
      "[S]earch recently [o]pened files",
    },
    ["<leader>sG"] = {
      function()
        require("telescope").extensions.live_grep_args.live_grep_args({ cwd = vim.fn.expand("%:p:h") })
      end,
      "[S]earch by [G]rep in current directory",
    },
  },
}

M.buffer = {
  n = {
    ["<leader>bd"] = { "<cmd>bp<bar>sp<bar>bn<bar>bd<CR>", "[B]uffer [D]elete" },
    ["<leader>bb"] = {
      function()
        require("telescope.builtin").buffers()
      end,
      "[B]rowse [B]uffers",
    },
  },
}

M.window = {
  n = {
    ["<leader>ws"] = { "<cmd> :split <CR>", "[W]indow Horizontal [S]plit" }, -- split horizontal
    ["<leader>wv"] = { "<cmd> :vsplit <CR>", "[W]indow [V]ertical Split" }, -- split vertical
    ["<leader>wh"] = { "<cmd> :TmuxNavigateLeft<CR>", "Go to Left [W]indow" },
    ["<leader>wj"] = { "<cmd> :TmuxNavigateDown<CR>", "Go to [W]indow Below" },
    ["<leader>wk"] = { "<cmd> :TmuxNavigateUp<CR>", "Go to Top [W]indow" },
    ["<leader>wl"] = { "<cmd> :TmuxNavigateRight<CR>", "Go to Right [W]indow" },
    ["<leader>wq"] = { "<C-w>q", "[W]indow [Q]uit" }, -- quit
  },
}

M.term = {
  n = {
    ["<leader>tf"] = { "<cmd> :ToggleTerm direction=float<CR>", "[T]erm [F]loat" },
    ["<leader>tt"] = { "<cmd> :ToggleTerm direction=tab<CR>", "[T]erm [T]ab" },
    ["<leader>th"] = { "<cmd> :ToggleTerm direction=horizontal<CR>", "[T]erm [H]orizontal" },
    ["<leader>tv"] = { "<cmd> :ToggleTerm direction=vertical<CR>", "[T]erm [V]ertical" },
    ["<leader>ht"] = {
      function()
        require("custom.term").htop:toggle()
      end,
      "[H]top",
    },
    ["<c-`>"] = { "<cmd> :ToggleTerm direction=horizontal<CR>", "[T]erm [H]orizontal" },
  },
}

M.git = {
  n = {
    ["<leader>gg"] = {
      function()
        require("custom.term").lazygit:toggle()
      end,
      "Lazy[G]it",
    },
    ["<leader>gl"] = {
      function()
        require("custom.term").lazygit:toggle()
      end,
      "[L]azy[G]it",
    },
  },
}

M.lsp = {
  n = {
    -- ["gD"] = {
    --   function()
    --     vim.lsp.buf.declaration()
    --   end,
    --   "lsp declaration",
    -- },
    --
    -- ["gd"] = {
    --   function()
    --     vim.lsp.buf.definition()
    --   end,
    --   "lsp definition",
    -- },

    ["gh"] = { "<cmd>Lspsaga lsp_finder<CR>" },
    -- ["K"] = { "<cmd>Lspsaga hover_doc<CR>", "Hover Documentation" },
    ["<leader>ld"] = { "<cmd>Lspsaga show_line_diagnostics<CR>", "[L]ine [D]iagnostics" },
    ["<leader>cd"] = { "<cmd>Lspsaga show_cursor_diagnostics<CR>", "[C]ursor [D]iagnostics" },
    ["<leader>ad"] = { "<cmd>Lspsaga show_buffer_diagnostics<CR>", "Buffer [D]iagnostics" },
  },
}

return M
