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
      extraOptions = { RequestTTY = "yes"; };
    };
    "ucare-10" = {
      hostname = "ucare-10.cs.uchicago.edu";
      forwardAgent = true;
      forwardX11 = true;
      extraOptions = { RequestTTY = "yes"; };
    };
  };

  home.packages = [
    (pkgs.writeShellScriptBin "cl-data" ''
      ssh cl-data "tmux attach || tmux"
    '')
    (pkgs.writeShellScriptBin "cl-data-p" ''
      ssh cl-data
    '')
  ];
}
