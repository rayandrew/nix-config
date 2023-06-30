{ config, pkgs, ... }:
let
  inherit (config.my-meta) username;
in
{
  imports = [
    ./xserver.nix
    ./wayland.nix
  ];

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  services = {
    # Enable printing
    printing = {
      enable = true;
      drivers = with pkgs; [ ];
    };
  };
}
