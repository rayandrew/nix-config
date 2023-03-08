{ flake, ... }:
{
  imports = [
    ../modules/meta.nix
  ];

  # Enable NixOS auto-upgrade
  system.autoUpgrade = {
    enable = true;
    allowReboot = false;
    flake = "github:rayandrew/nix-config";
  };

  services = {
    fail2ban.enable = true;
  };

  # nixos.home = {
  #   path = ../home-manager/vps.nix;
  # };
}
