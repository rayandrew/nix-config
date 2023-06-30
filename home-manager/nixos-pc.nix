{ flake, pkgs, ... }:

{
  imports = [
    ./nixos.nix
    # ./i3.nix
    ./sway
    ./graphical.nix
  ];

  home.packages = with pkgs; [ ];
}
