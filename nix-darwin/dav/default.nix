{ config
, lib
, pkgs
, flake
, ...
}:

let
  inherit (config.my-meta) orgDirPath;

  program = "sync-org-nc-webdav";

  configFile = pkgs.parseTemplateWithOut "${program}-config" ./sync.conf "sync.conf" {
    iniator = orgDirPath;
    target = "/Volumes/rayandrew/Org";
  };

  copyAction = pkgs.writeShellScriptBin program ''
    bash ${flake.inputs.osync}/osync.sh ${configFile}/sync.conf --summary
  '';
in
{
  config = lib.mkIf (!builtins.isNull orgDirPath) {
    environment.systemPackages = [ copyAction ];

    launchd.user.agents.org-dav = {
      # serviceConfig.Label = "nc-rs-dav";
      serviceConfig.ProgramArguments = [ "${pkgs.bash}/bin/bash" "-c" program ];

      # serviceConfig.KeepAlive = true;
      serviceConfig.RunAtLoad = true;
      serviceConfig.EnvironmentVariables = {
        PATH = "${pkgs.rsync}/bin:${copyAction}/bin:${config.environment.systemPath}";
      };
      serviceConfig.StartInterval = 600;
      # serviceConfig.StandardErrorPath = lib.mkDefault "/tmp/org-dav.err.log";
      # serviceConfig.StandardOutPath = lib.mkDefault "/tmp/org-dav.out.log";
    };
  };
}
