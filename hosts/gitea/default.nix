# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, flake, ... }:

let
  inherit (flake) inputs;
  inherit (config.my-meta) username;
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
    domain = "";
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
  };

  services.udev.extraRules = ''
    ATTR{address}=="96:00:01:e7:12:0c", NAME="eth0"
    ATTR{address}=="86:00:00:37:46:64", NAME="enp7s0"
  '';

  zramSwap.enable = true;
  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAIIF4r+0JPTUDj0/FdTLWebbkFfRXd3Gn11Ai1MZsMt rayandrew@cs.uchicago.edu"
  ];


  my-meta.nixConfigPath = "/etc/nixos";
  my-meta.projectsDirPath = "";
  my-meta.researchDirPath = "";
}
