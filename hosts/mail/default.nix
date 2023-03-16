# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, flake, ... }:

let
  inherit (flake) inputs;
  inherit (config.my-meta) username;
  inherit (config.users.users.${username}) home;
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
    hostName = "mail";
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
          { address = "5.161.206.121"; prefixLength = 32; }
        ];
        ipv6.addresses = [
          { address = "2a01:4ff:f0:939b::1"; prefixLength = 64; }
          { address = "fe80::9400:2ff:fe01:5dbc"; prefixLength = 64; }
        ];
        ipv4.routes = [{ address = "172.31.1.1"; prefixLength = 32; }];
        ipv6.routes = [{ address = "fe80::1"; prefixLength = 128; }];
      };
    };
    firewall.allowedTCPPorts = [ 80 443 25 587 ];
  };

  services.udev.extraRules = ''
    ATTR{address}=="96:00:02:01:5d:bc", NAME="eth0"
    ATTR{address}=="86:00:00:3c:ff:87", NAME="enp7s0"
  '';

  zramSwap.enable = true;

  my-meta.nixConfigPath = "${home}/.config/nix-config";
  my-meta.projectsDirPath = "";
  my-meta.researchDirPath = "";

  security.pam.enableSSHAgentAuth = true; # to make deploy-rs works

  users.users.${username}.shell = lib.mkForce pkgs.bash;

  services.smartd.enable = lib.mkForce false;

  ### MAIL CONFIGURATIONS ###
  mailserver = {
    enable = true;
    fqdn = "mail.rs.ht";
    domains = [ "rs.ht" ];

    loginAccounts = {
      "rs@rs.ht" = {
        hashedPasswordFile = secrets.rs-rs-ht;
        aliases = [ ];
      };
    };

    # Use Let's Encrypt certificates. Note that this needs to set up a stripped
    # down nginx and opens port 80.
    certificateScheme = 3;
  };

  services = {
    roundcube = {
      enable = true;
      # this is the url of the vhost, not necessarily the same as the fqdn of
      # the mailserver
      hostName = "mail.example.com";
      extraConfig = ''
        # starttls needed for authentication, so the fqdn required to match
        # the certificate
        $config['smtp_server'] = "tls://${config.mailserver.fqdn}";
        $config['smtp_user'] = "%u";
        $config['smtp_pass'] = "%p";
      '';
    };

    nginx.enable = true;
  };

  environment.systemPackages = with pkgs;[ unzip ];

  # secrets
  sops.secrets = {
    rs-rs-ht = {
      owner = username;
      mode = "0440";
      sopsFile = ./secrets.yaml;
    };
  };
}
