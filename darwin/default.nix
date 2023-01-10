{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ../modules/sketchybar
    ../modules/pam

    ./homebrew.nix
    ./hostname.nix
    ./kitty.nix # sudo keep TERMINFO_DIRS env
    ./my.nix
    ./sudo.nix
    ./system.nix
    ./sketchybar
    ./skhd
    ./yabai
    ./symlinks.nix
    inputs.agenix.darwinModule
    inputs.home-manager.darwinModules.home-manager
  ];

  hm.imports = [
    ./kitty.nix
    ./packages.nix
    ./skhd
    ./symlinks.nix
  ];
}
