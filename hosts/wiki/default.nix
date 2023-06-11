# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, flake, ... }:

let
  inherit (flake) inputs;
  inherit (config.my-meta) username;
  inherit (config.users.users.${username}) home;

  dokuwiki-template-mindthedark = pkgs.stdenv.mkDerivation rec {
    name = "mindthedark";
    version = "2021-12-24";
    src = pkgs.fetchFromGitHub {
      owner = "MrReSc";
      repo = "MindTheDark";
      rev = version;
      sha256 = "sha256-zDQobbPKzBGaxlRciytkeBVMicBmPR0uHlCEoC6Tj/w=";
    };
    installPhase = "mkdir -p $out; cp -R * $out/";
  };

  dokuwiki-template-adhominem = pkgs.stdenv.mkDerivation rec {
    name = "adhominem";
    version = "2023-05-04";
    src = pkgs.fetchFromGitHub {
      owner = "saschaleib";
      repo = "dokuwiki-template-ad-hominem";
      rev = "1edfda4a1b8e08b9a1fd8755137ce8b164277c78";
      sha256 = "sha256-UIG7rvroQfK85QZp0u2Wpfj5MAW1Hm6lyqcalu2L1SQ=";
    };
    patches = [
      ./remove-title-adhominem.patch
    ];
    installPhase = "mkdir -p $out; cp -R * $out/";
  };

  dokuwiki-template-typowiki = pkgs.stdenv.mkDerivation rec {
    name = "typowiki";
    version = "1.3";
    # src = pkgs.fetchzip {
    #   url = "https://github.com/axlevxa/typowiki/releases/download/${version}/v${version}-typowiki.zip";
    #   sha256 = "sha256-vmZ0DHZ4GC5bV/jSSpD3hK2KZTPqdfgVCu5BEKC+AE0=";
    #   stripRoot = false;
    # };
    src = pkgs.fetchFromGitHub {
      owner = "axlevxa";
      repo = "typowiki";
      rev = "f553d5120ae493aaa9b5ade9d4b16942612ece33";
      sha256 = "sha256-AGbZ5eA5zaYwtyf9DQxuwB6HEDlm8UrAbSMsbdJXk1E=";
    };
    patches = [ ];
    installPhase = "mkdir -p $out; cp -R typowiki/* $out/";
  };

  dokuwiki-plugin-edittable = pkgs.stdenv.mkDerivation rec {
    name = "edittable";
    version = "2023-06-09";
    src = pkgs.fetchFromGitHub {
      owner = "cosmocode";
      repo = "edittable";
      rev = "66785d9f22547c6cd3f695add99bed593cbc488c";
      sha256 = "sha256-zDQobbPKzBGaxlRciytkeBVMicBmPR0uHlCEoC6Tj/w=";
    };
    installPhase = "mkdir -p $out; cp -R * $out/";
  };

  dokuwiki-plugin-gitbacked = pkgs.stdenv.mkDerivation rec {
    name = "gitbacked";
    version = "2023-06-10";
    src = pkgs.fetchFromGitHub {
      owner = "woolfg";
      repo = "dokuwiki-plugin-gitbacked";
      rev = "00885c3bddfaf5cc3c9ac3f45a53342b77d30b22";
      sha256 = "sha256-oBul5Mu7rjiZbca0BjM9ZH/K119ljr1X5P1OIVborYU=";
    };
    installPhase = "mkdir -p $out; cp -R * $out/";
  };

  dokuwiki-plugin-dw2pdf = pkgs.stdenv.mkDerivation rec {
    name = "dw2pdf";
    version = "2023-06-10";
    src = pkgs.fetchFromGitHub {
      owner = "splitbrain";
      repo = "dokuwiki-plugin-dw2pdf";
      rev = "da60bb840dbb8c79fbfde65d6796fc6d598e1451";
      sha256 = "sha256-Hli/vwK1NpDDeiYes9zpQ+yYwlQyqZ7Xd5lK0qOUjWs=";
    };
    installPhase = "mkdir -p $out; cp -R * $out/";
  };
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

  boot.tmp.cleanOnBoot = true;
  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
    useOSProber = true;
  };

  networking = {
    hostName = "wiki";
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
          { address = "5.161.212.0"; prefixLength = 32; }
        ];
        ipv6.addresses = [
          { address = "2a01:4ff:f0:3e54::1"; prefixLength = 64; }
          { address = "fe80::9400:2ff:fe43:4353"; prefixLength = 64; }
        ];
        ipv4.routes = [{ address = "172.31.1.1"; prefixLength = 32; }];
        ipv6.routes = [{ address = "fe80::1"; prefixLength = 128; }];
      };
    };
    firewall.allowedTCPPorts = [
      80
      443
      993 # imap ssl
      465 # smtp ssl
    ];
  };

  services.udev.extraRules = ''
    ATTR{address}=="96:00:02:43:43:53", NAME="eth0"
  '';

  zramSwap.enable = true;

  my-meta.nixConfigPath = "${home}/.config/nix-config";
  my-meta.projectsDirPath = "";
  my-meta.researchDirPath = "";

  security.pam.enableSSHAgentAuth = true; # to make deploy-rs works

  users.users.${username}.shell = lib.mkForce pkgs.bash;

  services.smartd.enable = lib.mkForce false;

  environment.systemPackages = with pkgs;[ unzip ];

  services = {
    dokuwiki.sites."wiki.rs.ht" = {
      enable = true;
      templates = [
        dokuwiki-template-mindthedark
        dokuwiki-template-adhominem
        dokuwiki-template-typowiki
      ];
      plugins = [
        dokuwiki-plugin-edittable
        dokuwiki-plugin-gitbacked
        dokuwiki-plugin-dw2pdf
      ];
      usersFile = config.sops.secrets.users.path;
      aclFile = "/etc/wiki/acl.auth.php";
      settings = {
        title = "Ray Wiki";
        datadir = "/var/lib/dokuwiki-git/pages";
        mediadir = "/var/lib/dokuwiki-git/media";
        useacl = true;
        superuser = username;
        userewrite = true;
        baseurl = "https://wiki.rs.ht";
        # template = "adhominem";
        template = "typowiki";
        tpl.mindthedark.autoDark = true;
        tpl.adhominem.autoDark = true;
        disableactions = [ "register" ];
        plugin.gitbacked = {
          pushAfterCommit = true;
          repoPath = "/var/lib/dokuwiki-git";
          gitPath = "${pkgs.git}/bin/git";
        };
      };
    };

    phpfpm.pools."dokuwiki-wiki.rs.ht" = {
      phpEnv."PATH" = lib.makeBinPath [ pkgs.git pkgs.openssh ];
      phpEnv."GIT_SSH_COMMAND" = "\"ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ${config.sops.secrets.priv.path}\"";
    };

    nginx = {
      enable = true;
      virtualHosts."wiki.rs.ht" = {
        forceSSL = true;
        enableACME = true;
      };
    };
  };

  environment.etc."wiki/acl.auth.php" = {
    source = ./acl.auth.php;
    mode = "0440";
    user = config.users.users.dokuwiki.name;
    group = config.users.users.dokuwiki.group;
  };

  # users.users.dokuwiki = {
  #   isSystemUser = lib.mkForce true;
  #   isNormalUser = lib.mkForce false;
  #   # home = "/home/dokuwiki";
  #   # createHome = true;
  # };

  # secrets
  sops.secrets = {
    users = {
      owner = config.users.users.dokuwiki.name;
      group = config.users.users.dokuwiki.group;
      mode = "0440";
      sopsFile = ./secrets.yaml;
    };
    priv = {
      owner = config.users.users.dokuwiki.name;
      group = config.users.users.dokuwiki.group;
      mode = "0400";
      sopsFile = ./secrets.yaml;
    };
    pub = {
      owner = config.users.users.dokuwiki.name;
      group = config.users.users.dokuwiki.group;
      mode = "0400";
      sopsFile = ./secrets.yaml;
    };
  };
}
