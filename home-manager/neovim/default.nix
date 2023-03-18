{ flake, config, pkgs, lib, ... }:

# some configurations are taken from 
# https://github.com/NvChad/NvChad

let
  inherit (lib) concatStringsSep optional;
  inherit (config.lib.file) mkOutOfStoreSymlink;
  inherit (flake.inputs.nixvim.lib.${pkgs.system}) helpers;

  home = config.home.homeDirectory;
  populateEnv = ./populate-nvim-env.py;

  populateEnvScript = ''
    mkdir -p ${config.xdg.dataHome}/nvim/site/plugin
    ${pkgs.python39}/bin/python ${populateEnv} -o ${config.xdg.dataHome}/nvim/site/plugin
  '';

  # https://pablo.tools/blog/computers/nix-mustache-templates/
  templateFile = name: template: data:
    pkgs.stdenv.mkDerivation {
      name = "${name}";
      nativeBuildInpts = [ pkgs.mustache-go ];

      # Pass Json as file to avoid escaping
      passAsFile = [ "jsonData" ];
      jsonData = builtins.toJSON data;

      # Disable phases which are not needed. In particular the unpackPhase will
      # fail, if no src attribute is set
      phases = [ "buildPhase" "installPhase" ];

      buildPhase = ''
        echo $jsonDataPath
        ${pkgs.mustache-go}/bin/mustache $jsonDataPath ${template} > rendered_file
      '';

      installPhase = ''
        cp rendered_file $out
      '';
    };


in
{
  # Neovim

  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.neovim.enable
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;
    plugins = with pkgs; [
      # vimPlugins.lazy-nvim
      # vimPlugins.gruvbox-nvim
    ];
    extraLuaConfig = with pkgs; ''
      vim.opt.rtp:prepend("${vimPlugins.lazy-nvim}")

      vim.g.mapleader = " "
      vim.o.background = "dark"

      require("lazy").setup({
        { 
          dir = "${vimPlugins.gruvbox-nvim}",  
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
    '';
  };

  # xdg.configFile."nvim" = {
  #   source = ./config;
  #   recursive = false;
  # };

  # Config and plugins
  # xdg.configFile."nvim" = {
  #   source = "${pkgs.nvchad}";
  #   recursive = false;
  # };
  #
  home.packages = with pkgs; [
    #   nvchad
    #   (pkgs.writeShellScriptBin "update-nvim-env" ''
    #     #
    #     # update-nvim-env
    #     #
    #     # Update neovim env such that it can be used in neovide or other GUIs.
    #
    #     ${populateEnvScript}
    #   '')
    (pkgs.writeShellScriptBin "clean-nvim" ''
      rm -rf ${config.xdg.dataHome}/nvim
      rm -rf ${config.xdg.configHome}/nvim
      rm -rf ${config.xdg.cacheHome}/nvim
    '')
  ];
  #
  # home.activation.neovim = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
  #   echo "Populating neovim env..."
  #   ${populateEnvScript}
  # '';

  # programs.bash.initExtra = lib.mkAfter ''
  #   export EDITOR="${config.programs.neovim.package}/bin/nvim"
  # '';
  #
  # programs.zsh.initExtra = lib.mkAfter ''
  #   export EDITOR="${config.programs.neovim.package}/bin/nvim"
  # '';
}
# vim: foldmethod=marker
