{ config
, lib
, pkgs
, flake
, ...
}:

let
  inherit (config.my-meta) davDirPath;

  program = "sync-nc-webdav";


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
        mkdir -p $out
        cp rendered_file $out/sync.conf
      '';
    };


  configFile = parseTemplate "${program}-config" ./sync.conf {
    iniator = davDirPath;
    target = "/Volumes/rayandrew/";
  };

  copyAction = pkgs.writeShellScriptBin program ''
    # rsync -auv ${davDirPath}/* /Volumes/rayandrew/
    bash ${flake.inputs.osync}/osync.sh ${configFile}/sync.conf --summary
  '';
in
{
  config = lib.mkIf (!builtins.isNull davDirPath) {
    environment.systemPackages = [ copyAction ];

    launchd.user.agents.dav = {
      # serviceConfig.Label = "nc-rs-dav";
      serviceConfig.ProgramArguments = [ "${pkgs.bash}/bin/bash" "-c" program ];

      # serviceConfig.KeepAlive = true;
      serviceConfig.RunAtLoad = true;
      serviceConfig.EnvironmentVariables = {
        PATH = "${pkgs.rsync}/bin:${copyAction}/bin:${config.environment.systemPath}";
      };
      serviceConfig.StartInterval = 900;
      serviceConfig.StandardErrorPath = lib.mkDefault "/tmp/dav.err.log";
      serviceConfig.StandardOutPath = lib.mkDefault "/tmp/dav.out.log";
    };
  };
}
