{
  description = "Ray's Darwin System";

  inputs = {
    # Package sets
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # nixpkgs.url = "github:azuwis/nixpkgs/sketchybar";

    # Environment/system management
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    # home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Flake utilities
    flake-utils.url = "github:numtide/flake-utils";
    flake-utils-plus.url = "github:gytis-ivaskevicius/flake-utils-plus";
    flake-utils-plus.inputs.flake-utils.follows = "flake-utils";

    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };

    agenix.url = "github:ryantm/agenix/pull/107/head";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, flake-utils-plus, nixpkgs, darwin, ... }:
    let
      inherit (flake-utils-plus.lib)
        mkFlake exportModules exportPackages exportOverlays;
      inherit (inputs.nixpkgs.lib)
        attrValues makeOverridable optionalAttrs singleton;
    in mkFlake {
      inherit self inputs;

      channelsConfig = { allowUnfree = true; };

      # channels.nixpkgs.patches = inputs.nixpkgs.lib.mkIf inputs.nixpkgs.lib.stdenv.isDarwin [ ./patches/sketchybar.patch ];

      # channels.nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (inputs.nixpkgs.lib.getName pkg) [
      #   "spotify"
      # ];

      # Add some additional functions to `lib`.
      lib = inputs.nixpkgs.lib.extend (_: _: {
        mkDarwinSystem = import ./lib/mkDarwinSystem.nix inputs;
        lsnix = import ./lib/lsnix.nix;
      });

      # Overlays
      overlay = import ./overlay.nix;
      overlays = exportOverlays { inherit (self) pkgs inputs; };
      sharedOverlays = [ self.overlay flake-utils-plus.overlay ];

      outputsBuilder = channels: {
        packages = exportPackages self.overlays channels;
      };

      modules = exportModules [ ./common ./darwin ./hosts/midnight.nix ];

      hostDefaults = {
        modules = [ self.modules.common ];
        specialArgs = { inherit inputs; };
      };

      hosts.midnight = {
        system = "aarch64-darwin";
        modules = [ self.modules.darwin self.modules.midnight ];
        output = "darwinConfigurations";
        builder = darwin.lib.darwinSystem;
      };

      githubCI = self.hosts.midnight.override {
        system = "x86_64-darwin";
        username = "runner";
        my = {
          nix = "/Users/runner/work/nixpkgs/nixpkgs";
          projects = "/Users/runner/work/Projects";
          research = "/Users/runner/work/Research";
        };
        # nixConfigDirectory = "/Users/runner/work/nixpkgs/nixpkgs";
        extraModules = singleton { homebrew.enable = self.lib.mkForce false; };
      };
    };
}
