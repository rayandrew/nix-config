{ flake, pkgs, ... }:

{
  imports = [
    ./nixos.nix
    ./theme
    ./sway
    # ./sway
    ./graphical.nix
  ];

  home.packages = with pkgs; [ ];
}
