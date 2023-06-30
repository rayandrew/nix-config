{ config, pkgs, ... }:
let
  inherit (config.my-meta) username;
in
{
  imports = [
    ./xserver.nix
    # ./wayland.nix
    ./vpn.nix
  ];

  sound.enable = true;
  hardware.pulseaudio.enable = true;
  nixpkgs.config.pulseaudio = true;
  hardware.pulseaudio.package = pkgs.pulseaudioFull;
  hardware.enableAllFirmware = true;

  services = {
    # Enable printing
    printing = {
      enable = true;
      drivers = with pkgs; [ ];
    };
  };
}
