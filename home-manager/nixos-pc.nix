{ flake, pkgs, ... }:

{
  imports = [
    ./nixos.nix
    # ./i3.nix
    ./theme
    ./sway
    ./graphical.nix
  ];

  home.packages = with pkgs; [ ];
}
