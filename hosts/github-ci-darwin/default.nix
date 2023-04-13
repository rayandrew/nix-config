{ config, lib, ... }:

let
  inherit (config.my-meta) username;
  inherit (config.users.users.${username}) home;
  netDevices = [ "Wi-Fi" "USB 10/100/1000 LAN" ];
in
{
  imports = [ ../../nix-darwin ];

  networking.computerName = "runner";
  networking.hostName = "runner";
  networking.knownNetworkServices = netDevices;

  device = {
    type = "server";
    netDevices = netDevices;
  };

  my-meta.nixConfigPath = "${home}/.config/nix-config";
  my-meta.projectsDirPath = "${home}/Projects";
  my-meta.researchDirPath = "${home}/Research";


  homebrew.enable = lib.mkForce false;
  services.yabai.enable = lib.mkForce false;
  services.skhd.enable = lib.mkForce false;
  # services.sketchybar.enable = lib.mkForce false;
  # nix.registry.my.flake = inputs.self;
}
  
