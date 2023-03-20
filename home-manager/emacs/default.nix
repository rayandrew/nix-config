{ config
, lib
, pkgs
, ...
}:

let
  cfg = config.programs.emacs;

  # Modified from https://pablo.tools/blog/computers/nix-mustache-templates/
  parseTemplate = name: src: data:
    pkgs.stdenv.mkDerivation {
      inherit src;

      name = "${name}";
      nativeBuildInpts = [ pkgs.mustache-go pkgs.findutils ];

      # Pass Json as file to avoid escaping
      passAsFile = [ "jsonData" ];
      jsonData = builtins.toJSON data;

      # Disable phases which are not needed. In particular the unpackPhase will
      # fail, if no src attribute is set
      phases = [ "buildPhase" ];

      buildPhase = ''
        mkdir -p $out
        for file in $(find $src -type f -print); do
          stripped_path=''${file#"$src/"}
          dir_path=$(dirname $stripped_path)
          filename=$(basename $file)
          if [[ $dir_path == "." ]]; then
            dir_path=""
          else
            mkdir -p $out/$dir_path
          fi
          ${pkgs.mustache-go}/bin/mustache $jsonDataPath $file > "$out/$dir_path/$filename"
        done
      '';
    };
in
{
  programs.emacs = {
    enable = true;
    package = pkgs.emacsGit;
  };

  services.emacs = lib.mkIf (pkgs.stdenv.isLinux) {
    enable = true;
  };

  xdg.configFile."doom" = {
    source = ./doom;
    recursive = false;
  };

  programs.zsh.initExtra = lib.mkIf cfg.enable (lib.mkAfter ''
    alias en="${pkgs.emacs}/bin/emacs -nw"
    export PATH="${config.xdg.configHome}/emacs/bin:$PATH"
  '');

  home.activation.doom-sync = lib.hm.dag.entryAfter [ "doom-sync" ] ''
    echo "Doom sync..."
    if [[ -f ${config.xdg.configHome}/emacs/bin/doom ]]; then
      export PATH="${cfg.package}/bin:${pkgs.git}/bin:$PATH"
      ${config.xdg.configHome}/emacs/bin/doom sync
    fi
  '';
}
