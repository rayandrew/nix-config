{ config, pkgs, lib, ... }:
# Let-In ----------------------------------------------------------------------------------------{{{
let
  inherit (lib) concatStringsSep optional;
  inherit (config.lib.file) mkOutOfStoreSymlink;
  inherit (config.home.user-info) directory;

  populateEnvScript = ''
    mkdir -p ${config.xdg.dataHome}/nvim/site/plugin
    ${pkgs.python39}/bin/python ${config.xdg.configHome}/nvim/populate-env.py -o ${config.xdg.dataHome}/nvim/site/plugin
  '';
  # }}}
in {
  # Neovim
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.neovim.enable
  programs.neovim.enable = true;

  programs.neovim.viAlias = true;
  programs.neovim.vimAlias = true;

  # Config and plugins ------------------------------------------------------------------------- {{{

  # Put neovim configuration located in this repository into place in a way that edits to the
  # configuration don't require rebuilding the `home-manager` environment to take effect.
  # xdg.configFile."nvim".source = pkgs.fetchFromGitHub {
  #   owner = "rayandrew";
  #   repo = "nvim";
  #   rev = "435fdfef0619d191cdbbfb8a9dce4feff0633c15";
  #   sha256 = "sha256-UgVgTR/1Z+jfIK8Xg9IlBZKYjMZOjdNue8kP9RoHYH8=";
  # };
  xdg.configFile."nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${config.my.directory.projects}/nvim";
  # if lib.pathExists "/Users/rayandrew/Projects/nvim" then
  # else
  #   pkgs.fetchFromGitHub {
  #     owner = "rayandrew";
  #     repo = "nvim";
  #     rev = "435fdfef0619d191cdbbfb8a9dce4feff0633c15";
  #     sha256 = "sha256-UgVgTR/1Z+jfIK8Xg9IlBZKYjMZOjdNue8kP9RoHYH8=";
  #   };

  home.packages = [
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
