{ config, lib, pkgs, ... }:

{
  imports = [
    ../../modules/darwin/davmail
  ];
  
  services.davmail = {
    enable = true;
    package = pkgs.davmail;
  };

  launchd.agents.sketchybar.config.EnvironmentVariables = {
    PATH =
      lib.mkForce
        "${config.services.davmail.package}/bin:${config.my-meta.systemPath}/bin";
  };
}
