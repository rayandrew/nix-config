{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./home.nix
    ./homebrew.nix
    ./hostname.nix
    ./meta.nix
    ./sudo.nix
    ./sketchybar
    ./skhd
    ./yabai
    ./symlinks.nix
    ../overlays
    ../modules
    ../modules/darwin/sketchybar
    ../modules/darwin/pam
  ];
}
