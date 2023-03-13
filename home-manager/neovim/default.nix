{ flake, config, pkgs, lib, ... }:

# some configurations are taken from 
# https://github.com/NvChad/NvChad

let
  inherit (lib) concatStringsSep optional;
  inherit (config.lib.file) mkOutOfStoreSymlink;
  inherit (lib.nixvim) helpers;

  home = config.home.homeDirectory;
  populateEnv = ./populate-nvim-env.py;

  populateEnvScript = ''
    mkdir -p ${config.xdg.dataHome}/nvim/site/plugin
    ${pkgs.python39}/bin/python ${populateEnv} -o ${config.xdg.dataHome}/nvim/site/plugin
  '';
in
{
  # Neovim

  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.neovim.enable
  # programs.neovim.enable = true;
  #
  # programs.neovim.viAlias = true;
  # programs.neovim.vimAlias = true;
  #
  # # Config and plugins
  # xdg.configFile."nvim" = {
  #   source = "${pkgs.nvchad}";
  #   recursive = false;
  # };
  #
  # home.packages = with pkgs; [
  #   nvchad
  #   (pkgs.writeShellScriptBin "update-nvim-env" ''
  #     #
  #     # update-nvim-env
  #     #
  #     # Update neovim env such that it can be used in neovide or other GUIs.
  #
  #     ${populateEnvScript}
  #   '')
  # ];
  #
  # home.activation.neovim = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
  #   echo "Populating neovim env..."
  #   ${populateEnvScript}
  # '';

  programs.bash.initExtra = lib.mkAfter ''
    export EDITOR="${config.programs.neovim.package}/bin/nvim"
  '';

  programs.zsh.initExtra = lib.mkAfter ''
    export EDITOR="${config.programs.neovim.package}/bin/nvim"
  '';

  programs.nixvim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    plugins = {
      treesitter = {
        enable = true;
        nixGrammars = true;
        ensureInstalled = "all";
        moduleConfig.autotag = {
          enable = true;
          filetypes = [
            "html"
            "xml"
            "astro"
            "javascriptreact"
            "typescriptreact"
            "svelte"
            "vue"
          ];
        };
        moduleConfig.highlight = {
          additional_vim_regex_highlighting = [ "org" ];
          enable = true;
        };
      };

      comment-nvim.enable = true;

      lualine = {
        enable = true;
        theme = "gruvbox-material";
      };

      neorg = {
        enable = true;
        modules = {
          "core.defaults" = { };
          "core.norg.dirman".config.workspaces.work = "${home}/Notes/work";
          "core.norg.completion".config.engine = "nvim-cmp";
          "core.norg.concealer" = { };
          "core.norg.journal" = { };
        };
      };

      intellitab.enable = true;
      nix.enable = true;
      bufferline = {
        enable = true;
        diagnostics = "nvim_lsp";
        separatorStyle = "slant";
      };
      nvim-autopairs.enable = true;
      nvim-tree = {
        enable = true;
        package = pkgs.unstable.vimPlugins.nvim-tree-lua;
      };

      undotree.enable = true;
      surround.enable = true;

      lspkind = {
        enable = true;
        mode = "symbol_text";
        cmp = {
          enable = true;
          ellipsisChar = "…";
          menu = {
            buffer = "[Buffer]";
            nvim_lsp = "[LSP]";
            luasnip = "[LuaSnip]";
            nvim_lua = "[Lua]";
            latex_symbols = "[Latex]";
          };
          # before = ''
          #   function(_, item)
          #     local icon = lsp_icons[item.kind] or ""
          #     local strings = item.kind
          #
          #     icon = " " .. icon .. " "
          #     item.kind = string.format("%s %s", icon, strings)
          #
          #     return item
          #   end
          # '';
          # after = ''
          #   function(_, item, kind)
          #     local icon = lsp_icons[kind.kind] or ""
          #     -- local strings = vim.split(kind.kind, "%s", { trimempty = true })
          #     local strings = kind.kind
          #
          #     icon = " " .. icon .. " "
          #     kind.kind = string.format("%s %s", icon, strings)
          #
          #     return kind 
          #   end
          # '';
        };
      };

      luasnip.enable = true;

      lsp = {
        enable = true;
        servers = {
          rnix-lsp.enable = true;
          rust-analyzer.enable = true;
          clangd.enable = true;
          # zls.enable = true;
          pyright.enable = true;
          gopls.enable = true;
          elixirls.enable = true;
          # hls.enable = true;
          tsserver.enable = true;
          astro.enable = true;
        };

        # onAttach = ''
        #   vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()]]
        # '';
      };

      lsp-lines = {
        enable = true;
        currentLine = true;
      };

      lspsaga.enable = true;

      null-ls = {
        enable = true;
        sources = {
          formatting = {
            black.enable = true;
            nixpkgs_fmt.enable = true;
          };
          diagnostics = {
            shellcheck.enable = true;
          };
        };
      };

      trouble.enable = true;

      copilot-lua = {
        enable = true;
        package = pkgs.unstable.vimPlugins.copilot-lua;
        suggestion = {
          keymap = {
            accept = "<c-g>";
            accept_word = false;
            accept_line = false;
            next = "<c-j>";
            prev = "<c-k>";
            dismiss = "<c-f>";
          };
        };
      };
      copilot-lua-cmp.enable = true;
      cmp-copilot.enable = lib.mkForce false;
      cmp_luasnip.enable = true;

      toggleterm.enable = true;

      nvim-cmp = {
        # enable = true;
        enable = helpers.mkRaw ''
          function()
            if vim.bo.buftype == 'prompt' then
              return false
            end

            return true
          end
        '';
        sources = [
          { name = "luasnip"; }
          { name = "nvim_lsp"; }
          { name = "copilot"; }
          { name = "buffer"; }
          { name = "nvim_lua"; }
          { name = "path"; }
        ];
        snippet = {
          expand = helpers.mkRaw ''
            function(args)
              require("luasnip").lsp_expand(args.body)
            end
          '';
        };
        mappingPresets = [ "insert" ];
        mapping = {
          "<C-p>" = "cmp.mapping.select_prev_item()";
          "<C-n>" = "cmp.mapping.select_next_item()";
          "<C-d>" = "cmp.mapping.scroll_docs(-4)";
          "<C-f>" = "cmp.mapping.scroll_docs(4)";
          "<C-Space>" = "cmp.mapping.complete()";
          "<C-e>" = "cmp.mapping.close()";
          "<CR>" = "cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })";
          "<Tab>" = ''
            cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_next_item()
              elseif require("luasnip").expand_or_jumpable() then
                vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true), "")
              else
                fallback()
              end
            end, {
              "i",
              "s",
            })
          '';
          "<S-Tab>" = ''
            cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_prev_item()
              elseif require("luasnip").jumpable(-1) then
                vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-prev", true, true, true), "")
              else
                fallback()
              end
            end, {
              "i",
              "s",
            })
          '';
        };
        formatting = {
          fields = [ "abbr" "kind" "menu" ];
          # format = helpers.mkRaw ''
          #   function(_, item)
          #     local icon = lsp_icons[item.kind] or ""
          #     local strings = item.kind
          #   
          #     icon = " " .. icon .. " "
          #     item.kind = string.format("%s %s", icon, strings)
          #   
          #     return item
          #   end
          # '';
          # format = helpers.mkRaw ''
          #   function(_, item)
          #       local icon = lsp_icons[item.kind] or ""
          #   
          #       icon = " " .. icon .. " "
          #       item.menu = cmp_ui.lspkind_text and "   (" .. item.kind .. ")" or ""
          #       item.kind = icon
          #   
          #       return item
          #   end
          # '';
        };

        window.completion = {
          winhighlight = "Normal:CmpPmenu,CursorLine:CmpSel,Search:PmenuSel";
          # col_offset = -4;
          sidePadding = 1;
          scrollbar = false;
          # border = "single";
          border = helpers.mkRaw "cmp_border 'CmpBorder'";
        };

        window.documentation = {
          # winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None";
          winhighlight = "Normal:CmpDoc";
          border = helpers.mkRaw "cmp_border 'CmpDocBorder'";
        };
      };

      visual-multi = {
        enable = true;
        mappings = {
          "Find Under" = "<C-d>";
          "Find Subword Under" = "<C-d>";
          "Next" = "n";
          "Previous" = "N";
          "Skip" = "q";
          "Select All" = "<C-c>";
          "Visual All" = "<C-c>";
          "Exit" = "<Esc>";
        };
      };

      telescope = {
        enable = true;
        extensions.fzf-native.enable = true;
        defaults = {
          vimgrep_arguments = [
            "${pkgs.ripgrep}/bin/rg"
            "-L"
            "--color=never"
            "--no-heading"
            "--with-filename"
            "--line-number"
            "--column"
            "--smart-case"
          ];
          prompt_prefix = "   ";
          selection_caret = "  ";
          entry_prefix = "  ";
          initial_mode = "insert";
          selection_strategy = "reset";
          sorting_strategy = "ascending";
          layout_strategy = "horizontal";
          layout_config = {
            horizontal = {
              prompt_position = "top";
              preview_width = 0.55;
              results_width = 0.8;
            };
            vertical = {
              mirror = false;
            };
            width = 0.87;
            height = 0.80;
            preview_cutoff = 120;
          };
          file_sorter = helpers.mkRaw "require('telescope.sorters').get_fuzzy_file";
          file_ignore_patterns = [ "node_modules" ];
          generic_sorter = helpers.mkRaw "require('telescope.sorters').get_generic_fuzzy_sorter";
          path_display = [ "truncate" ];
          winblend = 0;
          border = { };
          borderchars = [ "─" "│" "─" "│" "╭" "╮" "╯" "╰" ];
          color_devicons = true;
          set_env = { "COLORTERM" = "truecolor"; };
          file_previewer = helpers.mkRaw "require('telescope.previewers').vim_buffer_cat.new";
          grep_previewer = helpers.mkRaw "require('telescope.previewers').vim_buffer_vimgrep.new";
          qflist_previewer = helpers.mkRaw "require('telescope.previewers').vim_buffer_qflist.new";
          buffer_previewer_maker = helpers.mkRaw "require('telescope.previewers').buffer_previewer_maker";
        };
        # extensions_list = [ "themes" "terms" ];
      };
    };

    colorschemes.gruvbox = {
      enable = true;
      contrastDark = "medium";
    };

    options = {
      mouse = "a";
      shiftwidth = 2;
      tabstop = 2;
      smartindent = true;
      expandtab = true;
      number = true;
      wrap = true;
      linebreak = true;
      hlsearch = false;
      relativenumber = true;
      smartcase = true;
      ignorecase = true;
      colorcolumn = "80";
      guicursor = "";

      undodir = "${home}/.cache/nvim/undodir";
      undofile = true;

      showmode = false;

      scrolloff = 4;
      clipboard = "unnamedplus";

      laststatus = 3;
    };

    globals.mapleader = " ";

    maps.normal = {
      # file
      "<leader>t" = "<CMD>NvimTreeToggle<CR>";
      "<leader>ff" = "<CMD>Telescope find_files<CR>";
      "<leader>ca" = "<CMD>Lspsaga code_action<CR>";

      # files
      "<leader>fF" = helpers.mkRaw ''
        function()
          require("telescope.builtin").find_files({ cwd = vim.fn.expand("%:p:h") })
        end
      '';
      "<leader>fo" = helpers.mkRaw ''
        function()
          require("telescope.builtin").oldfiles()
        end
      '';
      "<leader>fs" = "<CMD>:w<CR>";
      "<leader>fw" = helpers.mkRaw ''
        function() end
      '';

      # buffers
      "<leader>bd" = "<CMD>bp<bar>sp<bar>bn<bar>bd<CR>";
      "<leader>bb" = helpers.mkRaw "function() require('telescope.builtin').buffers() end";

      # Search
      "<leader>/" = "<CMD>Telescope grep_string<CR>";
      "<leader>sd" = helpers.mkRaw ''
        function()
          require("telescope.builtin").diagnostics()
          end
      '';
      "<leader>sf" = helpers.mkRaw ''
        function()
          require("telescope.builtin").find_files()
        end
      '';
      "<leader>sh" = helpers.mkRaw ''
        function()
          require("telescope.builtin").help_tags()
        end
      '';
      "<leader>sw" = helpers.mkRaw ''
        function()
          require("telescope.builtin").grep_string()
        end
      '';
      "<leader>sp" = helpers.mkRaw ''
        function()
          require("telescope.builtin").live_grep()
        end
      '';
      "<leader>sg" = helpers.mkRaw ''
        function()
          require("telescope.builtin").live_grep()
        end
      '';
      "<leader>so" = helpers.mkRaw ''
        function()
          require("telescope.builtin").oldfiles()
        end
      '';
      "<leader>sG" = helpers.mkRaw ''
        function()
          require("telescope").extensions.live_grep_args.live_grep_args({ cwd = vim.fn.expand("%:p:h") })
        end
      '';

      # Tabs
      "<TAB>" = "<CMD>BufferLineCycleNext<CR>";
      "<S-TAB>" = "<CMD>BufferLineCyclePrev<CR>";

      # Tree
      "<C-n>" = "<CMD>NvimTreeToggle<CR>";
      "<leader>e" = "<CMD>NvimTreeFocus<CR>";

      # Windows
      "<leader>ws" = "<CD>:split<CR>";
      "<leader>wv" = "<CMD>:vsplit<CR>";
      "<leader>wh" = "<CMD>:TmuxNavigateLeft<CR>";
      "<leader>wj" = "<CMD>:TmuxNavigateDown<CR>";
      "<leader>wk" = "<CMD>:TmuxNavigateUp<CR>";
      "<leader>wl" = "<CMD>:TmuxNavigateRight<CR>";
      "<leader>wq" = "<C-w>q";

      # LSP
      "gh" = "<cmd>Lspsaga lsp_finder<CR>";
      "K" = "<cmd>Lspsaga hover_doc<CR>";
      "<leader>ld" = "<cmd>Lspsaga show_line_diagnostics<CR>";
      "<leader>cd" = "<cmd>Lspsaga show_cursor_diagnostics<CR>";
      "<leader>ad" = "<cmd>Lspsaga show_buffer_diagnostics<CR>";

      # term
      "<leader>gg" = helpers.mkRaw ''
        function()
          term.lazygit:toggle()
        end
      '';
      "<leader>gl" = helpers.mkRaw ''
        function()
          term.htop:toggle()
        end
      '';

      # Movements
      "j" = "gj";
      "k" = "gk";
    };

    maps.insert = {
      "<C-S>" = "<C-O>:w<CR>";
    };

    extraConfigLua = ''
      require("scope").setup()
      require("colorizer").setup()
      require("orgmode").setup({
        org_agenda_files = { '~/org/ **/*' },
        org_default_notes_file = '~/org/refile.org',
      })
    '';

    extraConfigLuaPre = ''
      require('orgmode').setup_ts_grammar()
      local lsp_icons = {
        Namespace = "",
        Text = " ",
        Method = " ",
        Function = " ",
        Constructor = " ",
        Field = "ﰠ ",
        Variable = " ",
        Class = "ﴯ ",
        Interface = " ",
        Module = " ",
        Property = "ﰠ ",
        Unit = "塞 ",
        Value = " ",
        Enum = " ",
        Keyword = " ",
        Snippet = " ",
        Color = " ",
        File = " ",
        Reference = " ",
        Folder = " ",
        EnumMember = " ",
        Constant = " ",
        Struct = "פּ ",
        Event = " ",
        Operator = " ",
        TypeParameter = " ",
        Table = "",
        Object = " ",
        Tag = "",
        Array = "[]",
        Boolean = " ",
        Number = " ",
        Null = "ﳠ",
        String = " ",
        Calendar = "",
        Watch = " ",
        Package = "",
        [" Copilot"] = " ",
      }

      local function cmp_border(hl_name)
        return {
          { "╭", hl_name },
          { "─", hl_name },
          { "╮", hl_name },
          { "│", hl_name },
          { "╯", hl_name },
          { "─", hl_name },
          { "╰", hl_name },
          { "│", hl_name },
        }
        end

        local term = {}
        local Terminal = require("toggleterm.terminal").Terminal
        term.lazygit = Terminal:new({
          cmd = "lazygit",
          hidden = true,
          direction = "float",
          float_opts = {
            border = "double",
          },
          on_open = function(term)
            vim.cmd("startinsert!")
            vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
          end,
          on_close = function(_)
            vim.cmd("startinsert!")
          end,
        })
        
        term.htop = Terminal:new({
          cmd = "htop",
          hidden = true,
          direction = "float",
        })
    '';

    extraPlugins = with pkgs.vimPlugins; [
      vim-sleuth
      kanagawa-nvim
      nvim-ts-autotag
      orgmode
      vim-fugitive
      (pkgs.vimUtils.buildVimPlugin rec {
        pname = "scope-nvim";
        version = "2db6d31de8e3a98d2b41c0f0d1f5dc299ee76875";
        src = pkgs.fetchFromGitHub {
          owner = "tiagovla";
          repo = "scope.nvim";
          rev = version;
          sha256 = "10l7avsjcgzh0s29az4zzskqcp9jw5xpvdiih02rf7c1j85zxm85";
        };
      })
      (pkgs.vimUtils.buildVimPlugin rec {
        pname = "vim-tmux-navigator";
        version = "cdd66d6a37d991bba7997d593586fc51a5b37aa8";
        src = pkgs.fetchFromGitHub {
          owner = "christoomey";
          repo = "vim-tmux-navigator";
          rev = version;
          sha256 = "sha256-gF1b5aBQTNQm2hCY5aR+RSU4cCNG356Yg6uPnlgqS4o=";
        };
      })

      vim-endwise
      vim-terraform
      nvim-colorizer-lua
      gleam-vim
    ];

    extraPackages = [
      pkgs.xclip
    ];

    highlight = {
      PmenuSel = { bg = "#504945"; fg = "NONE"; };
      # PmenuSel = { bg = "#282C34"; fg = "NONE"; };
      Pmenu = { fg = "#ebdbb2"; bg = "#282828"; };

      CmpItemAbbrDeprecated = { fg = "#d79921"; bg = "NONE"; strikethrough = true; };
      CmpItemAbbrMatch = { fg = "#83a598"; bg = "NONE"; bold = true; };
      CmpItemAbbrMatchFuzzy = { fg = "#83a598"; bg = "NONE"; bold = true; };
      CmpItemMenu = { fg = "#b16286"; bg = "NONE"; italic = true; };

      CmpItemKindField = { fg = "#fbf1c7"; bg = "#fb4934"; };
      CmpItemKindProperty = { fg = "#fbf1c7"; bg = "#fb4934"; };
      CmpItemKindEvent = { fg = "#fbf1c7"; bg = "#fb4934"; };

      CmpItemKindText = { fg = "#fbf1c7"; bg = "#b8bb26"; };
      CmpItemKindEnum = { fg = "#fbf1c7"; bg = "#b8bb26"; };
      CmpItemKindKeyword = { fg = "#fbf1c7"; bg = "#b8bb26"; };

      CmpItemKindConstant = { fg = "#fbf1c7"; bg = "#fe8019"; };
      CmpItemKindConstructor = { fg = "#fbf1c7"; bg = "#fe8019"; };
      CmpItemKindReference = { fg = "#fbf1c7"; bg = "#fe8019"; };

      CmpItemKindFunction = { fg = "#fbf1c7"; bg = "#b16286"; };
      CmpItemKindStruct = { fg = "#fbf1c7"; bg = "#b16286"; };
      CmpItemKindClass = { fg = "#fbf1c7"; bg = "#b16286"; };
      CmpItemKindModule = { fg = "#fbf1c7"; bg = "#b16286"; };
      CmpItemKindOperator = { fg = "#fbf1c7"; bg = "#b16286"; };

      CmpItemKindVariable = { fg = "#fbf1c7"; bg = "#458588"; };
      CmpItemKindFile = { fg = "#fbf1c7"; bg = "#458588"; };

      CmpItemKindUnit = { fg = "#fbf1c7"; bg = "#d79921"; };
      CmpItemKindSnippet = { fg = "#fbf1c7"; bg = "#d79921"; };
      CmpItemKindFolder = { fg = "#fbf1c7"; bg = "#d79921"; };

      CmpItemKindMethod = { fg = "#fbf1c7"; bg = "#8ec07c"; };
      CmpItemKindValue = { fg = "#fbf1c7"; bg = "#8ec07c"; };
      CmpItemKindEnumMember = { fg = "#fbf1c7"; bg = "#8ec07c"; };

      CmpItemKindInterface = { fg = "#fbf1c7"; bg = "#83a598"; };
      CmpItemKindColor = { fg = "#fbf1c7"; bg = "#83a598"; };
      CmpItemKindTypeParameter = { fg = "#fbf1c7"; bg = "#83a598"; };

      FloatBorder = { fg = "#a89984"; };
    };
  };
}
# vim: foldmethod=marker
