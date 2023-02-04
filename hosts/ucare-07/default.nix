# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, flake, ... }:

let inherit (flake) inputs;
in {
  imports = [
    # Use `nixos-generate-config` to generate `hardware-configuration.nix` file
    ./hardware-configuration.nix
    ../../nixos/minimal.nix
    ../../nixos/security.nix
    ../../nixos/ssh.nix
    ../../nixos/vps.nix
    inputs.hardware.nixosModules.common-cpu-intel
  ];

  device = {
    type = "server";
    netDevices = [ "enp0s31f6" ];
  };

  # Bootloader.
  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/nvme0n1";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "ucare-07";
  # networking.hostId = "ucare-07";
  networking.domain = "cs.uchicago.edu";

  # Enable networking
  networking.networkmanager.enable = true;
  networking.usePredictableInterfaceNames = true;
  networking.interfaces.enp0s31f6 = {
    #name = "enp0s31f6";
    ipv4.addresses = [
      {
        address = "128.135.11.17";
        prefixLength = 24;
      }
    ];
  };
  networking.defaultGateway = "128.135.11.1";
  networking.nameservers = [
    "128.135.164.141"
    "128.135.24.141"
  ];
}
