{ flake, pkgs, ... }:

{
  imports = [
    ./nixos.nix
    ./i3.nix
    ./graphical.nix
  ];

  home.packages = with pkgs; [ ];
}
