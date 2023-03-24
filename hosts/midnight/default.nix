{ config, lib, pkgs, flake, ... }:

let
  inherit (config.my-meta) username;
  inherit (config.users.users.${username}) home;
  netDevices = [ "Wi-Fi" "USB 10/100/1000 LAN" ];
in
{
  imports = [ ../../nix-darwin ];

  networking.computerName = "midnight";
  networking.hostName = "midnight";
  networking.knownNetworkServices = netDevices;

  device = {
    type = "laptop";
    netDevices = netDevices;
    # netDevices = [ ];
  };

  my-meta.nixConfigPath = "${home}/.config/nix-config";
  my-meta.projectsDirPath = "${home}/Projects";
  my-meta.researchDirPath = "${home}/Research";
  my-meta.davDirPath = "${home}/Cloud";
  # nix.registry.my.flake = inputs.self;
}
