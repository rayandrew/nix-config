{
  description = "Ray's Nix Configs";

  inputs = {
    # Package sets
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    stable.url = "github:rayandrew/nixpkgs/nixos-22.11";
    master.url = "github:NixOS/nixpkgs/master";
    hardware.url = "github:NixOS/nixos-hardware";
    home = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
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
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-modules = {
      url = "github:SuperSandro2000/nixos-modules";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    # Flake utilities
    flake-utils.url = "github:numtide/flake-utils";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };

    # Rust
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.url = "flake-utils";
    };

    # Fonts
    sf-mono-liga-src = {
      url = "github:shaunsingh/SFMono-Nerd-Font-Ligaturized";
      flake = false;
    };

    # Neovim
    nixvim = {
      url = "github:rayandrew/nixvim";
      # url = "/Users/rayandrew/Code/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    simple-nixos-mailserver = {
      url = "gitlab:simple-nixos-mailserver/nixos-mailserver/nixos-22.11";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-22_11.follows = "stable";
    };

    emacs-overlay = {
      url = "github:rayandrew/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    osync = {
      url = "github:deajan/osync";
      flake = false;
    };

    firefox-darwin = {
      url = "github:bandithedoge/nixpkgs-firefox-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur.url = "github:nix-community/NUR";
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      inherit (import ./lib/attrsets.nix { inherit (nixpkgs) lib; })
        recursiveMergeAttrs;
      inherit (import ./lib/flake.nix inputs)
        mkGHActionsYAMLs mkRunCmd mkDarwinConfig mkNixOSConfig mkHomeConfig
        mkDevShell mkDeployConfig mkChecks;
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
      (mkNixOSConfig {
        hostname = "ucare-07";
        deployConfigurations = {
          fastConnection = true;
          remoteBuild = true;
        };
      })
      (mkNixOSConfig {
        hostname = "gitea";
        deployConfigurations = {
          fastConnection = true;
          remoteBuild = true;
        };
      })
      (mkNixOSConfig {
        hostname = "mail";
        deployConfigurations = {
          fastConnection = true;
          remoteBuild = true;
        };
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

      # Deploy config
      (mkDeployConfig { })

      # Checks
      (mkChecks { })

      # DevShells
      (mkDevShell { })
    ]);
}
