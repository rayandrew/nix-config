{ config, lib, pkgs, ... }:

{
  nix.package = pkgs.nix;
  time.timeZone = "America/Chicago";

  # Nix configuration ------------------------------------------------------------------------------

  nix.settings = {
    substituters =
      [ "https://cache.nixos.org/" "https://rayandrew.cachix.org" ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "rayandrew.cachix.org-1:kJnvdWgUyErPGaQWgh/yyu91szgRYD+V/WQ4Dbc4n9M="
    ];

    trusted-users = [ "@admin" ];

    # https://github.com/NixOS/nix/issues/7273
    # auto-optimise-store = false;
    auto-optimise-store = lib.mkDefault true;

    experimental-features = [ "nix-command" "flakes" ];

    extra-platforms = lib.mkIf (pkgs.system == "aarch64-darwin") [
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    keep-outputs = true;
    tarball-ttl = 43200;
  };

  nix.generateNixPathFromInputs = true;
  nix.generateRegistryFromInputs = true;
  nix.linkInputs = true;
  nix.configureBuildUsers = true;

  # users.defaultUserShell = pkgs.zsh;

  # Shells -----------------------------------------------------------------------------------------

  # Add shells installed by nix to /etc/shells file
  environment.shells = with pkgs; [ bashInteractive fish zsh ];

  # Make Fish the default shell
  programs.fish.enable = true;
  programs.fish.useBabelfish = true;
  programs.fish.babelfishPackage = pkgs.babelfish;
  # Needed to address bug where $PATH is not properly set for fish:
  # https://github.com/LnL7/nix-darwin/issues/122
  programs.fish.shellInit = ''
    for p in (string split : ${config.environment.systemPath})
      if not contains $p $fish_user_paths
        set -g fish_user_paths $fish_user_paths $p
      end
    end
  '';
  # environment.variables.SHELL = "${pkgs.zsh}/bin/zsh";

  # Install and setup ZSH to work with nix(-darwin) as well
  programs.zsh.enable = true;
}
