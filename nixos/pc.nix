{ config, pkgs, ... }:
let
  inherit (config.my-meta) username;
in
{
  imports = [
    ./wayland.nix
  ];

  services = {
    # Enable printing
    printing = {
      enable = true;
      drivers = with pkgs; [ ];
    };
  };
}
