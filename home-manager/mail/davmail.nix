{ config, lib, pkgs, ... }:

{
  imports = [
    ../../modules/darwin/davmail
  ];

  # home.packages = with pkgs; [
  #   davmail
  # ];

  services.davmail = {
    enable = false;
    package = pkgs.davmail;
    url = "https://outlook.office365.com/EWS/Exchange.asmx";
    config = {
      davmail.mode = "O365Interactive";
      # davmail.mode = "O365Manual";
    };
  };

  launchd.agents.davmail.config.EnvironmentVariables = {
    PATH =
      lib.mkForce
        "${config.services.davmail.package}/bin:${config.my-meta.systemPath}/bin";
  };
}
