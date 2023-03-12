{ config, lib, pkgs, flake, system, ... }:

{
  imports = [
    ../modules/meta.nix
  ];

  options.nixos.home = {
    enable = pkgs.lib.mkDefaultOption "home config";
    username = lib.mkOption {
      description = "Main username";
      type = lib.types.str;
      default = config.my-meta.username;
    };
    path = lib.mkOption {
      description = "Home manager path";
      type = lib.types.path;
      default = ../home-manager/nixos.nix;
    };
  };

  config = lib.mkIf config.nixos.home.enable {
    home-manager = {
      useUserPackages = true;
      users.${config.nixos.home.username} = config.nixos.home.path;
      extraSpecialArgs = {
        inherit flake system;
        super = config;
      };
    };
  };
}
