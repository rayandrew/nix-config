{ pkgs
, lib
, config
, ...
}:

{
  imports = [
    ../../modules/darwin/mbsync
  ];

  services.mbsync-darwin = {
    enable = true;
    startInterval = lib.mkIf (pkgs.stdenv.isDarwin) 300;
    postExec = ''
      ${pkgs.notmuch}/bin/notmuch new
    '';
  };

  launchd.agents.mbsync-darwin.config.EnvironmentVariables = {
    PATH =
      lib.mkForce
        "${config.services.davmail.package}/bin:${config.my-meta.systemPath}/bin";
  };
}
