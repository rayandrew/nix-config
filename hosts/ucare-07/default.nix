# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ flake, lib, config, ... }:

let
  inherit (flake) inputs;
  inherit (config.my-meta) username;
  inherit (config.users.users.${username}) home;
in
{
  imports = [
    # Use `nixos-generate-config` to generate `hardware-configuration.nix` file
    ./hardware-configuration.nix
    ../../nixos/minimal.nix
    ../../nixos/security.nix
    ../../nixos/ssh.nix
    ../../nixos/vps.nix
    inputs.hardware.nixosModules.common-cpu-intel
    flake.inputs.home.nixosModules.home-manager
  ];

  device = {
    type = "server";
    netDevices = [ "enp0s31f6" ];
  };

  boot.loader.grub = {
    enable = true;
    device = "/dev/nvme0n1";
    useOSProber = true;
  };

  networking = {
    hostName = "ucare-07";
    domain = "cs.uchicago.edu";
    networkmanager.enable = true;
    usePredictableInterfaceNames = lib.mkDefault true;
    interfaces.enp0s31f6 = {
      ipv4.addresses = [
        {
          address = "128.135.11.17";
          prefixLength = 24;
        }
      ];
    };
    defaultGateway = "128.135.11.1";
    nameservers = [
      "128.135.164.141"
      "128.135.24.141"
    ];
  };

  my-meta.nixConfigPath = "${home}/.config/nix-config";
  my-meta.projectsDirPath = "${home}/Projects";
  my-meta.researchDirPath = "${home}/Research";

  users.groups.data.members = [
    "root"
    username
  ];

  # secrets
  sops.secrets = {
    nix-ssh-key = {
      owner = username;
      # group = username;
      mode = "0440";
      sopsFile = ./secrets.yaml;
      # neededForUsers = true;
    };
  };
}
