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
    package = pkgs.emacsGit;
  };

  services.emacs = lib.mkIf (pkgs.stdenv.isLinux) {
    enable = true;
  };

  programs.zsh.initExtra = lib.mkIf cfg.enable (lib.mkAfter ''
    alias en="${pkgs.emacs}/bin/emacs -nw"
  '');
}
