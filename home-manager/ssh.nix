{ config, pkgs, lib, ... }:

let
  inherit (lib) optionalString mkAfter;
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
    # "gpu-ray-0" = {
    #   hostname = "129.114.109.115";
    #   user = "rayandrew";
    #   forwardAgent = true;
    #   forwardX11 = true;
    #   extraOptions = {
    #     RequestTTY = "yes";
    #     UserKnownHostsFile = "/dev/null";
    #     StrictHostKeyChecking = "no";
    #   };
    # };
    "mail" = {
      user = "rayandrew";
      hostname = "mail.rs.ht";
      port = 22;
      forwardAgent = true;
      forwardX11 = true;
      extraOptions = { RequestTTY = "yes"; };
    };
    "wiki" = {
      user = "rayandrew";
      hostname = "rs.ht";
      port = 22;
      forwardAgent = true;
      forwardX11 = true;
      extraOptions = { RequestTTY = "yes"; };
    };
    "gitea" = {
      hostname = "git.rs.ht";
      port = 22;
      forwardAgent = true;
      forwardX11 = true;
      extraOptions = { RequestTTY = "yes"; };
    };
    "git.rs.ht" = {
      hostname = "git.rs.ht";
      port = 22;
      forwardAgent = true;
    };
    "*.github.com" = {
      extraOptions = {
        AddKeysToAgent = "yes";
        # UseKeychain = "yes";
        # IdentityFile = "${config.home.homeDirectory}/.ssh/id_ed25519";
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

    # Bastion
    "cs-uc" = {
      user = "rayandrew";
      hostname = "linux.cs.uchicago.edu";
      extraOptions = {
        # ControlMaster = "auto";
        # ControlPersist = "yes";
        LogLevel = "FATAL";
      };
    };
    "ucare-gpu-1" = {
      hostname = "ucare-gpu-1.a.cs.uchicago.edu";
      forwardAgent = true;
      forwardX11 = true;
      extraOptions = {
        RequestTTY = "yes";
        # ControlMaster = "auto";
        # ControlPersist = "yes";
        LogLevel = "FATAL";
      };
      user = "rayandrew";
      proxyJump = "cs-uc";
      forwardX11Trusted = true;
    };

    # Argonne
    "login-gce" = {
      user = "rayandrew";
      hostname = "logins.cels.anl.gov";
      extraOptions = {
        ControlMaster = "auto";
        ControlPersist = "yes";
        LogLevel = "FATAL";
      };
    };
    "homes-gce" = lib.hm.dag.entryAfter [ "login-gce" ] {
      user = "rayandrew";
      hostname = "homes.cels.anl.gov";
      proxyJump = "login-gce";
      forwardX11Trusted = true;
    };
    "*.cels.anl.gov !logins.cels.anl.gov" = lib.hm.dag.entryAfter [ "login-gce" ] {
      user = "rayandrew";
      proxyJump = "login-gce";
      forwardX11Trusted = true;
    };
    "bebop" = lib.hm.dag.entryBefore [ "*.lcrc.anl.gov" ] {
      user = "rayandrew";
      hostname = "bebop.lcrc.anl.gov";
      forwardX11Trusted = true;
      extraOptions = {
        ControlMaster = "auto";
        ControlPersist = "yes";
        LogLevel = "FATAL";
      };
    };
    "swing" = lib.hm.dag.entryBefore [ "*.lcrc.anl.gov" ] {
      user = "rayandrew";
      hostname = "swing.lcrc.anl.gov";
      forwardX11Trusted = true;
      extraOptions = {
        ControlMaster = "auto";
        ControlPersist = "yes";
        LogLevel = "FATAL";
      };
    };
    "*.lcrc.anl.gov" = {
      user = "rayandrew";
      forwardX11Trusted = true;
      extraOptions = {
        ControlMaster = "auto";
        ControlPersist = "yes";
        LogLevel = "FATAL";
      };
    };

    "box" = {
      user = "u369179";
      hostname = "box.rs.ht";
      port = 23;
      forwardAgent = true;
      forwardX11 = true;
      extraOptions = {
        RequestTTY = "yes";
        ControlMaster = "auto";
        ControlPersist = "yes";
        LogLevel = "FATAL";
      };
    };

    "clperf-box" = {
      user = "u369179-sub1";
      hostname = "box.rs.ht";
      port = 23;
      forwardAgent = true;
      forwardX11 = true;
      extraOptions = {
        RequestTTY = "yes";
        ControlMaster = "auto";
        ControlPersist = "yes";
        LogLevel = "FATAL";
      };
    };
  };

  # Configuration related to casks
  programs.ssh.extraConfig = mkAfter ''
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
