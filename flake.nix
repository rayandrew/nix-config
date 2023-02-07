{
  description = "Ray's Nix Configs";

  inputs = {
    # Package sets
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    stable.url = "github:NixOS/nixpkgs/release-22.11";
    hardware.url = "github:NixOS/nixos-hardware";
    home = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.utils.follows = "flake-utils";
    };
    nix-darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    deadnix = {
      url = "github:astro/deadnix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.utils.url = "flake-utils";
    };
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      # inputs.nixpkgs.url = "nixpkgs";
      inputs.utils.url = "flake-utils";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix/feat/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Flake utilities
    flake-utils.url = "github:numtide/flake-utils";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      inherit (import ./lib/attrsets.nix { inherit (nixpkgs) lib; })
        recursiveMergeAttrs;
      inherit (import ./lib/flake.nix inputs)
        mkGHActionsYAMLs mkRunCmd mkDarwinConfig mkNixOSConfig mkHomeConfig
        mkDevShell mkDeployConfig;# mkChecks
    in
    (recursiveMergeAttrs [
      # Templates
      {
        templates = {
          default = self.outputs.templates.new-darwin;
          new-darwin = {
            path = ./templates/new-darwin;
            description = "Create a new Darwin host";
          };
          new-nixos = {
            path = ./templates/new-nixos;
            description = "Create a new NixOS host";
          };
        };
      }

      # Darwin 
      (mkDarwinConfig {
        hostname = "midnight";
        system = "aarch64-darwin";
      })
      (mkDarwinConfig {
        hostname = "github-ci-darwin";
        system = "x86_64-darwin";
      })

      # NixOS
      (mkNixOSConfig { hostname = "ucare-07"; })

      # Home configurations
      (mkHomeConfig { hostname = "home-linux"; })
      (mkHomeConfig {
        hostname = "home-macos";
        configuration = ./home-manager/macos.nix;
        system = "x86_64-darwin";
        homePath = "/Users";
      })

      # Commands
      (mkRunCmd {
        name = "formatCheck";
        text = ''
          find . -name '*.nix' \
            ! -name 'hardware-configuration.nix' \
            ! -name 'cachix.nix' \
            ! -path './modules/home-manager/*' \
            ! -path './modules/nixos/*' \
            -exec nixpkgs-fmt --check {} \+
        '';
      })
      (mkRunCmd {
        name = "format";
        text = ''
          find . -name '*.nix' \
            ! -name 'hardware-configuration.nix' \
            ! -name 'cachix.nix' \
            ! -path './modules/home-manager/*' \
            ! -path './modules/nixos/*' \
            -exec nixpkgs-fmt {} \+
        '';
      })

      # GitHub Actions
      (mkGHActionsYAMLs [
        "build-and-cache"
        "update-flakes"
        "update-flakes-darwin"
      ])

      # Deploy config
      (mkDeployConfig { })

      # Checks
      # (mkChecks { })

      # DevShells
      (mkDevShell { })
    ]);
}
