{
  description = "Ray's Darwin System";

  inputs = {
    # Package sets

    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixpkgs-22.11-darwin";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixos-stable.url = "github:NixOS/nixpkgs/nixos-22.11";

    # Environment/system management
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-unstable";

    # Flake utilities
    flake-compat = { url = "github:edolstra/flake-compat"; flake = false; };
    flake-utils.url = "github:numtide/flake-utils";

    # Other sources
    comma.url = "github:nix-community/comma";
    comma.inputs.nixpkgs.follows = "nixpkgs-unstable";
    comma.inputs.utils.follows = "flake-utils";
    comma.inputs.flake-compat.follows = "flake-compat";
    
  };

  outputs = { self, darwin, nixpkgs, home-manager, flake-utils, ... }@inputs:
  let 

    inherit (darwin.lib) darwinSystem;
    inherit (inputs.nixpkgs-unstable.lib) attrValues makeOverridable optionalAttrs singleton;

    homeStateVersion = "23.05";

    # Configuration for `nixpkgs`
    nixpkgsDefaults = {
      config = { allowUnfree = true; };
      overlays = attrValues self.overlays ++ [
        # add inputs if necessary
      ] ++ singleton (
        # Sub in x86 version of packages that don't build on Apple Silicon yet
        final: prev: (optionalAttrs (prev.stdenv.system == "aarch64-darwin") {
          inherit (final.pkgs-x86)
            niv;
        }) // {
          # Add other overlays here if needed.
        }
      );
    }; 

    primaryUserDefaults = {
        username = "rayandrew";
        fullName = "Ray Andrew";
        email = "4437323+rayandrew@users.noreply.github.com";
        directory = {
          "nix" = "/Users/rayandrew/.config/nixpkgs";
          "projects"  = "/Users/rayandrew/Projects";
        };
      };
  in
  {
      # Add some additional functions to `lib`.
      lib = inputs.nixpkgs-unstable.lib.extend (_: _: {
        mkDarwinSystem = import ./lib/mkDarwinSystem.nix inputs;
        lsnix = import ./lib/lsnix.nix;
      });

      # Overlays --------------------------------------------------------------------------------

      overlays = {
        # Overlays to add different versions `nixpkgs` into package set
        pkgs-master = _: prev: {
          pkgs-master = import inputs.nixpkgs-master {
            inherit (prev.stdenv) system;
            inherit (nixpkgsDefaults) config;
          };
        };
        pkgs-stable = _: prev: {
          pkgs-stable = import inputs.nixpkgs-stable {
            inherit (prev.stdenv) system;
            inherit (nixpkgsDefaults) config;
          };
        };
        pkgs-unstable = _: prev: {
          pkgs-unstable = import inputs.nixpkgs-unstable {
            inherit (prev.stdenv) system;
            inherit (nixpkgsDefaults) config;
          };
        };
        apple-silicon = _: prev: optionalAttrs (prev.stdenv.system == "aarch64-darwin") {
          # Add access to x86 packages system is running Apple Silicon
          pkgs-x86 = import inputs.nixpkgs-unstable {
            system = "x86_64-darwin";
            inherit (nixpkgsDefaults) config;
          };
        };

	comma = final: prev: {
          comma = inputs.comma;
	};
    };


    # My `nix-darwin` modules that are pending upstream, or patched versions waiting on upstream
    # fixes.
    darwinModules = {
      programs-nix-index = 
        # Additional configuration for `nix-index` to enable `command-not-found` functionality with Fish.
        { config, lib, pkgs, ... }:

        {
          config = lib.mkIf config.programs.nix-index.enable {
            programs.fish.interactiveShellInit = ''
              function __fish_command_not_found_handler --on-event="fish_command_not_found"
                ${if config.programs.fish.useBabelfish then ''
                command_not_found_handle $argv
                '' else ''
                ${pkgs.bashInteractive}/bin/bash -c \
                  "source ${config.progams.nix-index.package}/etc/profile.d/command-not-found.sh; command_not_found_handle $argv"
                ''}
              end
            '';
            };
        };

	ray-bootstrap = import ./darwin/bootstrap.nix;
        ray-defaults = import ./darwin/defaults.nix;
        ray-general = import ./darwin/general.nix;
        ray-homebrew = import ./darwin/homebrew.nix;
	ray-wm = import ./darwin/wm.nix;

        # Modules I've created
        users-primaryUser = import ./modules/darwin/users.nix;
    };

    homeManagerModules = {
  	ray-colors = import ./home/colors.nix;
	ray-fish = import ./home/fish.nix;
	ray-git = import ./home/git.nix;
	ray-kitty = import ./home/kitty.nix;
	ray-neovim = import ./home/neovim.nix;
	ray-packages = import ./home/packages.nix;
	ray-starship = import ./home/starship.nix;
	ray-tmux = import ./home/tmux.nix;
	ray-ssh = import ./home/ssh.nix;

        colors = import ./modules/home/colors;
        programs-neovim-extras = import ./modules/home/programs/neovim/extras.nix;
        programs-kitty-extras = import ./modules/home/programs/kitty/extras.nix;
        home-user-info = { lib, config, ... }: {
          options.home.user-info =
            (self.darwinModules.users-primaryUser { inherit lib config; }).options.users.primaryUser;
        };
    };

    # My `nix-darwin` configs
      
    darwinConfigurations = rec {
       bootstrap-x86 = makeOverridable darwin.lib.darwinSystem {
         system = "x86_64-darwin";
         modules = [ ./darwin/bootstrap.nix { nixpkgs = nixpkgsDefaults; } ];
       };
      bootstrap-arm = self.darwinConfigurations.bootstrap-x86.override {
        system = "aarch64-darwin";
      };
      midnight = makeOverridable self.lib.mkDarwinSystem (primaryUserDefaults // {
        modules = attrValues self.darwinModules ++ singleton {
            nixpkgs = nixpkgsDefaults;
            networking.computerName = "midnight";
            networking.hostName = "midnight";
            networking.knownNetworkServices = [
              "Wi-Fi"
              "USB 10/100/1000 LAN"
            ];
            nix.registry.my.flake = inputs.self;
        };
        inherit homeStateVersion;
        homeModules = attrValues self.homeManagerModules;
      });
    };

     homeConfigurations.rayandrew = home-manager.lib.homeManagerConfiguration {
        pkgs = import inputs.nixpkgs-unstable (nixpkgsDefaults // { system = "x86_64-linux"; });
        modules = attrValues self.homeManagerModules ++ singleton ({ config, ... }: {
          home.username = config.home.user-info.username;
          home.homeDirectory = "/home/${config.home.username}";
          home.stateVersion = homeStateVersion;
          home.user-info = primaryUserDefaults // {
            directory = {
              nix = "${config.home.homeDirectory}/.config/nixpkgs";
              projects = "${config.home.homeDirectory}/Projects";
            };
          };
        });
      };
   } // flake-utils.lib.eachDefaultSystem (system: {
      # Re-export `nixpkgs-unstable` with overlays.
      # This is handy in combination with setting `nix.registry.my.flake = inputs.self`.
      # Allows doing things like `nix run my#prefmanager -- watch --all`
      legacyPackages = import inputs.nixpkgs-unstable (nixpkgsDefaults // { inherit system; });

      # Development shells ----------------------------------------------------------------------{{{
      # Shell environments for development
      # With `nix.registry.my.flake = inputs.self`, development shells can be created by running,
      # e.g., `nix develop my#python`.
      devShells = let pkgs = self.legacyPackages.${system}; in
        {
          python = pkgs.mkShell {
            name = "python310";
            inputsFrom = attrValues {
              inherit (pkgs.pkgs-master.python310Packages) black isort;
              inherit (pkgs) poetry python310 pyright;
            };
          };
        };
      # }}}
    });
}
