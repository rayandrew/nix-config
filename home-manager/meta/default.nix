{ lib, pkgs, flake, super, ... }:

let inherit (flake) inputs;
in {
  # Import overlays
  imports = [ ../../overlays ../../modules/meta.nix ];

  # Add some Nix related packages
  home.packages = with pkgs; [
    hydra-check
    nix-update
    nix-whereis
    nixpkgs-fmt
    nixpkgs-review
  ];

  # To make cachix work you need add the current user as a trusted-user on Nix
  # sudo echo "trusted-users = $(whoami)" >> /etc/nix/nix.conf
  # Another option is to add a group by prefixing it by @, e.g.:
  # sudo echo "trusted-users = @wheel" >> /etc/nix/nix.conf
  nix = {
    package = lib.mkDefault pkgs.nix;
    settings = (import ../../shared/nix-conf.nix { inherit lib; }) // {
      extra-substituters = [
        "https://cache.nixos.org/"
        "https://nix-community.cachix.org"
        "https://rayandrew-nix-config.cachix.org"
        "https://rayandrew.cachix.org"
      ];
      extra-trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "rayandrew-nix-config.cachix.org-1:on0ZZRm+vpJW+D4vv5NxHamNRIRwjQovpckETxz7MYs="
        "rayandrew.cachix.org-1:kJnvdWgUyErPGaQWgh/yyu91szgRYD+V/WQ4Dbc4n9M="
      ];
    };
  };

  # Set custom nixpkgs config (e.g.: allowUnfree), both for this
  # config and for ad-hoc nix commands invocation
  nixpkgs.config = import ./nixpkgs-config.nix // {
    # FIXME: why is this necessary only for HM standalone?
    allowUnfreePredicate = _: true;
  };
  xdg.configFile."nixpkgs/config.nix".source = ./nixpkgs-config.nix;

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;
    # Without git we may be unable to build this config
    git.enable = true;
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.11";

  # Inherit config from NixOS or homeConfigurations
  my-meta = super.my-meta;
}
