{ config, lib, pkgs, ... }:

{
  imports = [
    (lib.mkAliasOptionModule [ "hm" ] [ "home-manager" "users" config.my.username ])
    ./my.nix
    ./system.nix
  ];

  hm.imports = [
    ./direnv.nix
    ./git.nix
    ./gnupg.nix
    ./my.nix
    ./neovim.nix
    ./nix-index.nix
    ./packages.nix
    ./ssh.nix
    ./fish.nix
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  hm = {
    home.stateVersion = "23.05";
    systemd.user.startServices = "sd-switch";
  };
}
