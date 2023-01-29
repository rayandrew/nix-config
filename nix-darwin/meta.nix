{ pkgs, config, lib, flake, ... }:

with lib;

{
  imports = [ ../cachix.nix ];

  my-meta.systemPath = builtins.replaceStrings [ "$HOME" "$USER" ] [
    "/Users/${config.my-meta.username}"
    config.my-meta.username
  ]
    config.environment.systemPath;
  nix = import ../shared/nix.nix { inherit pkgs flake; };
  services.nix-daemon.enable = true;
}
