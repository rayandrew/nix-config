{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ../modules/sketchybar

    ./homebrew.nix
    ./hostname.nix
    ./kitty.nix # sudo keep TERMINFO_DIRS env
    ./my.nix
    ./sudo.nix
    ./system.nix
    ./sketchybar
    ./skhd
    ./yabai
    inputs.agenix.darwinModule
    inputs.home-manager.darwinModules.home-manager
  ];

  hm.imports = [
    ./kitty.nix
    ./packages.nix
    ./skhd
  ];
}
