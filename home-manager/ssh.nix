{ config, pkgs, lib, ... }:

let inherit (lib) optionalString mkAfter;
in {
  # SSH 
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.ssh.enable
  programs.ssh.enable = true;

  programs.ssh.matchBlocks = {
    "cl-data" = {
      hostname = "192.5.87.68";
      user = "rayandrew";
      forwardAgent = true;
      forwardX11 = true;
      extraOptions = { RequestTTY = "yes"; };
    };
    "ucare-7" = {
      hostname = "ucare-7.cs.uchicago.edu";
      user = "rayandrew";
      forwardAgent = true;
      forwardX11 = true;
      extraOptions = { RequestTTY = "yes"; };
    };
    "ucare-10" = {
      hostname = "ucare-10.cs.uchicago.edu";
      user = "rayandrew";
      forwardAgent = true;
      forwardX11 = true;
      extraOptions = { RequestTTY = "yes"; };
    };
    "ucare-mini" = {
      hostname = "ucare-min.cs.uchicago.edu";
      user = "ucare";
      forwardAgent = true;
      forwardX11 = true;
      extraOptions = { RequestTTY = "yes"; };
    };
  };

  # Configuration related to casks
  programs.ssh.extraConfig = mkAfter ''
    ${optionalString pkgs.stdenv.isDarwin ''
      # Only set `IdentityAgent` not connected remotely via SSH.
      # This allows using agent forwarding when connecting remotely.
      Match host * exec "test -z $SSH_TTY"
        IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
    ''}
  '';

  home.packages = [
    (pkgs.writeShellScriptBin "cl-data" ''
      ssh cl-data "tmux attach || tmux"
    '')
    (pkgs.writeShellScriptBin "cl-data-p" ''
      ssh cl-data
    '')
  ];
}
