{ config
, lib
, pkgs
, ...
}:

let
  cfg = config.programs.emacs;
in
{
  programs.emacs = {
    enable = true;
    # package = pkgs.emacsUnstable;
  };

  services.emacs = lib.mkIf (pkgs.stdenv.isLinux) {
    enable = false;
    # package = pkgs.emacsUnstable;
  };

  # xdg.configFile."doom" = {
  #   source = ./doom;
  #   recursive = false;
  # };

  # programs.zsh.initExtra = lib.mkIf cfg.enable (lib.mkAfter ''
  #   alias e="${config.programs.emacs.package}/bin/emacs -nw"
  #   export PATH="${config.xdg.configHome}/emacs/bin:$PATH"
  # '');

  # home.activation.doom-sync = lib.hm.dag.entryAfter [ "doom-sync" ] ''
  #   echo "Doom sync..."
  #   if [[ -f ${config.xdg.configHome}/emacs/bin/doom ]]; then
  #     export PATH="${cfg.package}/bin:${pkgs.git}/bin:$PATH"
  #     ${config.xdg.configHome}/emacs/bin/doom sync
  #     ${config.xdg.configHome}/emacs/bin/doom env
  #   fi
  # '';
}
