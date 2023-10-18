{ config
, lib
, pkgs
, ...
}:

let
  inherit (pkgs.stdenv) isDarwin isLinux;
in
{
  programs.emacs = {
    enable = true;
    package =
      if isDarwin then
        pkgs.emacs-unstable.overrideAttrs
          (oldAttrs: {
            withXwidgets = true;
          }) else pkgs.emacsUnstable;
  };

  services.emacs = lib.mkIf (isLinux) {
    enable = false;
    # package = pkgs.emacsUnstable;
  };

  
  home.packages = with pkgs; [
    emacsPackages.pdf-tools
    emacsPackages.mu4e
  ];

  
  programs.zsh.initExtra = lib.mkIf config.programs.emacs.enable (lib.mkAfter ''
    get_emacs_lib_path() {
      cd ${config.my-meta.nixConfigPath} >/dev/null 2>&1

      echo ${pkgs.emacsPackages.pdf-tools}
      echo ${pkgs.emacsPackages.mu4e}
  
      # nix eval nixpkgs#emacsPackages.mu4e.outPath
      # nix eval nixpkgs#emacsPackages.pdf-tools.outPath
    }
  '');

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
