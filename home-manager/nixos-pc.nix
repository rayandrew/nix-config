{ flake, pkgs, ... }:

{
  imports = [
    ./nixos.nix
    ./theme
    ./i3
    # ./sway
    ./graphical.nix
  ];

  home.packages = with pkgs; [ ];
}
