{ flake, pkgs, ... }:

{
  imports = [
    ./nixos.nix
    ./i3.nix
  ];

  home.packages = with pkgs; [ ];
}
