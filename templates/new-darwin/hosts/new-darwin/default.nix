# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, flake, ... }:

let
  inherit (flake) inputs;
  netDevices = [ "Wi-Fi" "USB 10/100/1000 LAN" ];
in
{
  imports = [ ../../nix-darwin ];

  device = {
    type = "laptop";
    netDevices = netDevices;
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "<hostname>";
  networking.knownNetworkServices = netDevices;
}
