{ flake, pkgs, ... }:

{
  imports = [
    ./nixos.nix
    # ./i3.nix
    ./sway.nix
    ./graphical.nix
  ];

  home.packages = with pkgs; [ ];
}
