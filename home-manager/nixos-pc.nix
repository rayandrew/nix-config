{ flake, pkgs, ... }:

{
  imports = [
    ./nixos.nix
    ./theme
    # ./sway
    ./i3
    ./graphical.nix
  ];

  home.packages = with pkgs; [
    mullvad-vpn
    # pkgs.nur.repos.LuisChDev.nordvpn
  ];
}
