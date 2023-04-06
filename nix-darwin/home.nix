{ config, lib, pkgs, flake, system, ... }:

let inherit (config.my-meta) username;
in {
  imports = [
    flake.inputs.home.darwinModules.home-manager
  ];

  programs.zsh.enable = true;
  environment.shells = [ pkgs.zsh ];

  users.users.${username} = {
    home = "/Users/${username}";
    shell = "${pkgs.zsh}/bin/zsh";
  };

  home-manager = {
    # useGlobalPkgs = true;
    useUserPackages = true;
    users.${username} = ../home-manager/macos.nix;
    extraSpecialArgs = {
      inherit flake system;
      super = config;
    };
    sharedModules = [ flake.inputs.sops-nix.homeManagerModule ];
  };
}
