{
  description = "Ray's Nix Configs";

  inputs = {
    # Package sets
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # Environment/system management
    nix-darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # home manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    deadnix = {
      url = "github:astro/deadnix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.utils.url = "flake-utils";
    };

    # Flake utilities
    flake-utils.url = "github:numtide/flake-utils";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, ... }@inputs:
    let
      inherit (flake-utils.lib) eachDefaultSystem;
      inherit (import ./lib/attrsets.nix { inherit (nixpkgs) lib; })
        recursiveMergeAttrs;
      inherit (import ./lib/flake.nix inputs)
        mkGHActionsYAMLs mkRunCmd mkNixOSConfig mkDarwinConfig mkHomeConfig;
    in
    (recursiveMergeAttrs [
      # Templates
      {
        templates = {
          default = self.outputs.templates.new-host;
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

      # Systems
      (mkDarwinConfig {
        hostname = "midnight";
        system = "aarch64-darwin";
      })

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
    ]);
}
