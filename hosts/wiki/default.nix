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
      templates = [ dokuwiki-template-mindthedark ];
      plugins = [ dokuwiki-plugin-edittable ];
      settings = {
        title = "Ray Wiki";
        useacl = true;
        userewrite = true;
        baseurl = "https://wiki.rs.ht";
        template = "mindthedark";
        tpl.mindthedark.autoDark = true;
      };
    };

    nginx = {
      enable = true;
      virtualHosts."wiki.rs.ht" = {
        forceSSL = true;
        enableACME = true;
      };
    };
  };

  # secrets
  sops.secrets = { };
}
