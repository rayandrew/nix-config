{ config, pkgs, lib, ... }:

let
  inherit (lib) optionalString mkAfter;
  giteaHost = {
    hostname = "git.rs.ht";
    port = 22;
    forwardAgent = true;
    forwardX11 = true;
    extraOptions = { RequestTTY = "yes"; };
  };
  controlChannel = "${config.home.homeDirectory}/.ssh/.control_channels";
in
{
  # SSH 
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.ssh.enable
  programs.ssh.enable = true;

  programs.ssh.serverAliveInterval = 60;
  programs.ssh.serverAliveCountMax = 120;

  programs.ssh.controlPath = "${controlChannel}/%h:%p:%r";

  programs.ssh.matchBlocks = {
    "gpu-ray-0" = {
      hostname = "192.5.86.158";
      user = "rayandrew";
      forwardAgent = true;
      forwardX11 = true;
      extraOptions = { RequestTTY = "yes"; };
    };
    "mail" = {
      user = "rayandrew";
      hostname = "mail.rs.ht";
      port = 22;
      forwardAgent = true;
      forwardX11 = true;
      extraOptions = { RequestTTY = "yes"; };
    };
    "gitea" = giteaHost // {
      user = "rayandrew";
    };
    "git.rs.ht" = giteaHost;
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
      extraOptions = {
        RequestTTY = "yes";
        IdentityFile = "${config.home.homeDirectory}/.ssh/id_ed25519";
      };
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

    # Argonne
    "login-gce" = {
      user = "ac.rayandrew";
      hostname = "logins.cels.anl.gov";
      extraOptions = {
        ControlMaster = "auto";
        ControlPersist = "yes";
        LogLevel = "FATAL";
      };
    };
    "homes-gce" = lib.hm.dag.entryAfter [ "login-gce" ] {
      user = "ac.rayandrew";
      hostname = "homes.cels.anl.gov";
      proxyJump = "login-gce";
      forwardX11Trusted = true;
    };
    "*.cels.anl.gov" = lib.hm.dag.entryAfter [ "login-gce" ] {
      user = "ac.rayandrew";
      proxyJump = "login-gce";
      forwardX11Trusted = true;
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
    Match host * exec "test -z $SSH_TTY"
      IdentityFile "${config.home.homeDirectory}/.ssh/id_ed25519"
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

  home.activation.ssh-control = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    echo "Creating SSH control directory..."
    mkdir -p ${controlChannel}
  '';
}
