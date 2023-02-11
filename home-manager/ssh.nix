{ config, pkgs, lib, ... }:

let
  inherit (lib) optionalString mkAfter;
  gitea = {
    hostname = "git.rs.ht";
    user = "rayandrew";
    port = 2222;
    forwardAgent = true;
    forwardX11 = true;
    extraOptions = { RequestTTY = "yes"; };
  };
in
{
  # SSH 
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.ssh.enable
  programs.ssh.enable = true;

  programs.ssh.serverAliveInterval = 60;
  programs.ssh.serverAliveCountMax = 120;

  programs.ssh.matchBlocks = {
    "gitea" = gitea;
    "git.rs.ht" = gitea;
    "*.github.com" = {
      extraOptions = {
        AddKeysToAgent = "yes";
        # UseKeychain = "yes";
        IdentityFile = "${config.home.homeDirectory}/.ssh/id_ed25519";
        # IgnoreUnknown = "UseKeychain";
      };
    };
    "cl-data" = {
      hostname = "192.5.87.68";
      user = "rayandrew";
      forwardAgent = true;
      forwardX11 = true;
      extraOptions = { RequestTTY = "yes"; };
    };
    "ucare-07" = {
      hostname = "ucare-07.cs.uchicago.edu";
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
      hostname = "ucare-mini.cs.uchicago.edu";
      user = "ucare";
      forwardAgent = true;
      forwardX11 = true;
      extraOptions = { RequestTTY = "yes"; };
    };
  };

  # Configuration related to casks
  programs.ssh.extraConfig = mkAfter ''
      ${optionalString pkgs.stdenv.isLinux ''
    # Only set `IdentityAgent` not connected remotely via SSH.
    # This allows using agent forwarding when connecting remotely.
    Match host * exec "test -z $SSH_TTY"
      IdentityFile "${config.home.homeDirectory}/.ssh/id_ed25519"
      ''}
    #   ${optionalString pkgs.stdenv.isDarwin ''
    # # Only set `IdentityAgent` not connected remotely via SSH.
    # # This allows using agent forwarding when connecting remotely.
    # Match host * exec "test -z $SSH_TTY"
    #   IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
    #   ''}
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
