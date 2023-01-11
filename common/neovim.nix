{ config, pkgs, lib, ... }:
# Let-In ----------------------------------------------------------------------------------------{{{
let
  inherit (lib) concatStringsSep optional;
  inherit (config.lib.file) mkOutOfStoreSymlink;
  inherit (config.home.user-info) directory;
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
  xdg.configFile."nvim".source = pkgs.fetchFromGitHub {
    owner = "rayandrew";
    repo = "nvim";
    rev = "b44fb865fa71f1bd27166e6591fcac197d56bb16";
    sha256 = "0c41p3g01pz3lnzpnv89xlan16rmh2xd3l5ypvmzj1z8i6l4ccwi";
  };

  # xdg.configFile."nvim" = {
  #  source = localNvim;
  #  recursive = true;
  # };
  # xdg.configFile."nvim".source = if builtins.pathExists localNvim 
  #   then 
  #     builtins.trace ''${localNvim}'' mkOutOfStoreSymlink localNvim 
  #     # mkOutOfStoreSymlink localNvim 
  #   else 
  #     builtins.trace ''hmm'' pkgs.fetchFromGitHub {
  #       owner = "rayandrew";
  #       repo = "nvim";
  #       rev = "main";
  #       sha256 = "0nkq5fbgd8pq806lankb2br0i313cly8m43wnkvnraq301pc0mn9";
  #    };

  # From personal addon module `../modules/home/programs/neovim/extras.nix`
  # programs.neovim.extras.termBufferAutoChangeDir = true;
  # programs.neovim.extras.nvrAliases.enable = true;
  # programs.neovim.extras.defaultEditor = true;

  # }}}

  # Required packages -------------------------------------------------------------------------- {{{

  programs.neovim.extraPackages = with pkgs; [ ];
  # }}}
}
# vim: foldmethod=marker
