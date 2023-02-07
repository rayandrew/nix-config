{ config, pkgs, lib, ... }:
# Let-In ----------------------------------------------------------------------------------------{{{
let
  inherit (lib) concatStringsSep optional;
  inherit (config.lib.file) mkOutOfStoreSymlink;
  inherit (config.home.user-info) directory;

  customNvChad = ./nvchad-custom;

  populateEnvScript = ''
    mkdir -p ${config.xdg.dataHome}/nvim/site/plugin
    # ${pkgs.python39}/bin/python ${config.xdg.configHome}/nvim/populate-env.py -o ${config.xdg.dataHome}/nvim/site/plugin
  '';
  # }}}
in
{
  # Neovim
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.neovim.enable
  programs.neovim.enable = true;

  programs.neovim.viAlias = true;
  programs.neovim.vimAlias = true;

  # Config and plugins ------------------------------------------------------------------------- {{{

  xdg.configFile."nvim" = {
    source = "${pkgs.nvchad}";
    recursive = true;
  };

  xdg.configFile."nvim/lua/custom" = {
    source = customNvChad;
    # recursive = true;
  };

  home.packages = with pkgs; [
    nvchad
    (pkgs.writeShellScriptBin "update-nvim-env" ''
      #
      # update-nvim-env
      #
      # Update neovim env such that it can be used in neovide or other GUIs.
      #
      ${populateEnvScript}
    '')
  ];

  home.activation.neovim = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    echo "Populating neovim env..."
    ${populateEnvScript}
  '';

  # Required packages -------------------------------------------------------------------------- {{{

  programs.neovim.extraPackages = with pkgs; [ ];
  # }}}
}
# vim: foldmethod=marker
