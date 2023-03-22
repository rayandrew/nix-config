# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, flake, ... }:

let
  inherit (flake) inputs;
  inherit (config.my-meta) username;
  inherit (config.users.users.${username}) home;
  giteaSshPort = 22;
in
{
  imports = [
    ./hardware-configuration.nix
    ../../nixos/minimal.nix
    ../../nixos/security.nix
    ../../nixos/ssh.nix
    ../../nixos/vps.nix
    inputs.hardware.nixosModules.common-cpu-intel
  ];

  device = {
    type = "server";
    netDevices = [ "eth0" "enp7s0" ];
  };

  boot.cleanTmpDir = true;
  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
    useOSProber = true;
  };

  networking = {
    hostName = "gitea";
    nameservers = [
      "8.8.8.8"
    ];
    defaultGateway = "172.31.1.1";
    defaultGateway6 = {
      address = "fe80::1";
      interface = "eth0";
    };
    dhcpcd.enable = false;
    usePredictableInterfaceNames = lib.mkForce false;
    interfaces = {
      eth0 = {
        ipv4.addresses = [
          { address = "5.161.195.146"; prefixLength = 32; }
        ];
        ipv6.addresses = [
          { address = "2a01:4ff:f0:df96::1"; prefixLength = 64; }
          { address = "fe80::9400:1ff:fee7:120c"; prefixLength = 64; }
        ];
        ipv4.routes = [{ address = "172.31.1.1"; prefixLength = 32; }];
        ipv6.routes = [{ address = "fe80::1"; prefixLength = 128; }];
      };
    };
    firewall.allowedTCPPorts = [ 80 443 giteaSshPort ];
  };

  services.udev.extraRules = ''
    ATTR{address}=="96:00:01:e7:12:0c", NAME="eth0"
    ATTR{address}=="86:00:00:37:46:64", NAME="enp7s0"
  '';

  zramSwap.enable = true;

  my-meta.nixConfigPath = "${home}/.config/nix-config";
  my-meta.projectsDirPath = "";
  my-meta.researchDirPath = "";

  security.pam.enableSSHAgentAuth = true; # to make deploy-rs works

  users.users.${username}.shell = lib.mkForce pkgs.bash;

  services.smartd.enable = lib.mkForce false;

  ### GITEA CONFIGURATIONS ###

  services = {
    gitea = rec {
      enable = true;
      appName = "git.rs.ht";
      domain = "git.rs.ht";
      rootUrl = "https://${domain}/";
      httpPort = 3003;
      package = pkgs.unstable.gitea;

      database.type = "postgres";

      repositoryRoot = "/var/lib/gitea/repositories";

      lfs.enable = true;

      dump = {
        # Is a nice feature once we have a dedicated backup storage.
        # For now it is disabled, since it delays `nixos-rebuild switch`.
        enable = false;
        backupDir = "/var/lib/gitea/dump";
      };

      settings = {
        cors = {
          ALLOW_DOMAIN = config.services.gitea.domain;
          ENABLED = true;
          SCHEME = "https";
        };
        cron.ENABLED = true;
        "cron.delete_generated_repository_avatars".ENABLED = true;
        "cron.delete_old_actions".ENABLED = true;
        "cron.delete_old_system_notices".ENABLED = true;
        "cron.repo_health_check".TIMEOUT = "300s";
        "cron.resync_all_sshkeys" = {
          ENABLED = true;
          RUN_AT_START = true;
        };
        database.LOG_SQL = false;
        indexer.REPO_INDEXER_ENABLED = true;
        log = {
          LEVEL = "Info";
          DISABLE_ROUTER_LOG = true;
        };
        mailer = {
          ENABLED = false;
          FROM = "git@rs.ht";
          MAILER_TYPE = "sendmail";
          SENDMAIL_PATH = "/run/wrappers/bin/sendmail";
          SENDMAIL_ARGS = "--";
        };
        other.SHOW_FOOTER_VERSION = false;
        picture = {
          # this also disables libravatar
          DISABLE_GRAVATAR = false;
          ENABLE_FEDERATED_AVATAR = true;
          GRAVATAR_SOURCE = "libravatar";
          REPOSITORY_AVATAR_FALLBACK = "random";
        };
        server = {
          ENABLE_GZIP = true;
          SSH_AUTHORIZED_KEYS_BACKUP = false;
          SSH_DOMAIN = domain;
          START_SSH_SERVER = giteaSshPort != 22;
          SSH_PORT = giteaSshPort;
        };
        service = {
          DISABLE_REGISTRATION = true;
          NO_REPLY_ADDRESS = "no-reply@rs.ht";
          REGISTER_EMAIL_CONFIRM = true;
          ENABLE_NOTIFY_MAIL = true;
        };
        session = {
          COOKIE_SECURE = lib.mkForce true;
          PROVIDER = "db";
          SAME_SITE = "strict";
        };
        "ssh.minimum_key_sizes" = {
          ECDSA = -1;
          RSA = 4095;
        };
        time.DEFAULT_UI_LOCATION = config.time.timeZone;
        ui = {
          DEFAULT_THEME = "arc-green";
          EXPLORE_PAGING_NUM = 25;
          FEED_PAGING_NUM = 50;
          ISSUE_PAGING_NUM = 25;
        };
      };
    };

    nginx = {
      enable = true;
      virtualHosts."git.rs.ht" = {
        forceSSL = true;
        enableACME = true;
        locations."/".proxyPass = "http://localhost:${toString config.services.gitea.httpPort}";
      };
    };

    openssh = {
      enable = true;
      extraConfig = ''
        Match User gitea
          AllowAgentForwarding no
          AllowTcpForwarding no
          PermitTTY no
          X11Forwarding no
      '';
    };

    postgresql = {
      package = pkgs.postgresql_14;
      upgrade.stopServices = [ "gitea" ];
    };
  };

  environment.systemPackages = with pkgs; [ postgresql unzip ];
}
