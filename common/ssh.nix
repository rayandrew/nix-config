{ config, pkgs, lib, ... }:

{
  # SSH 
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.ssh.enable
  programs.ssh.enable = true;

  programs.ssh.matchBlocks = {
    "cl-data" = {
      hostname = "192.5.87.68";
      forwardAgent = true;
      forwardX11 = true;
    };
  };
}
