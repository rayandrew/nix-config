{ config, lib, pkgs, ... }:

{
  imports = [ ];
  hm.imports = [ ];

  networking.computerName = "midnight";
  networking.hostName = "midnight";
  networking.knownNetworkServices = [
    "Wi-Fi"
      "USB 10/100/1000 LAN"
  ];

  # config.my.directory = {
  #   nix = "${config.home.homeDirectory}/.config/nixpkgs";
  #   projects = "${config.home.homeDirectory}/Projects";
  # };
  # nix.registry.my.flake = inputs.self;
}
