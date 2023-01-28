{ config, lib, pkgs, ... }:

{
  imports = [ ];
  hm.imports = [ ];

  networking.computerName = "runner";
  # networking.hostName = "runner";
  # networking.knownNetworkServices = [ "Wi-Fi" "USB 10/100/1000 LAN" ];

  # config.my = {
  #   username = "runner";
  #   directory = {
  #     nix = "/Users/runner/work/nixpkgs/nixpkgs";
  #     projects = "/Users/runner/work/Projects";
  #     research = "/Users/runner/work/Research";
  #   };
  # };

  homebrew.enable = lib.mkForce false;
}
