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
    ./emacs.nix
    ./yabai
    ./symlinks.nix
    ./preferences.nix
    ../overlays
    ../modules
    ../modules/darwin/sketchybar
    ../modules/darwin/pam
    ../shared/fonts.nix
  ];
}
