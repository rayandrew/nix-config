{ config, pkgs, ... }:
let
  inherit (config.my-meta) username;
in
{
  services = {
    # Enable printing
    printing = {
      enable = true;
      drivers = with pkgs; [ ];
    };
  };
}
