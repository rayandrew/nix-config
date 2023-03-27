{ pkgs, ... }:

# https://pablo.tools/blog/computers/nix-mustache-templates/
{
  parseTemplate = name: template: data:
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
        ${pkgs.mustache-go}/bin/mustache $jsonDataPath ${template} > rendered_file
      '';

      installPhase = ''
        cp rendered_file $out
      '';
    };

  parseTemplateWithOut = name: template: outName: data:
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
        ${pkgs.mustache-go}/bin/mustache $jsonDataPath ${template} > rendered_file
      '';

      installPhase = ''
        mkdir -p $out
        cp rendered_file $out/${outName}
      '';
    };
  parseTemplateDir = name: src: data:
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
}
