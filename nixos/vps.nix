{ config, pkgs, ... }:
{
  imports = [ ];

  # Enable NixOS auto-upgrade
  system.autoUpgrade = {
    enable = true;
    allowReboot = true;
    flake = "github:rayandrew/nix-config";
  };

  services = {
    fail2ban.enable = true;
  };
}
