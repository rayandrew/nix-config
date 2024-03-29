# Shamelessly copied from https://github.com/thiagokokada/nix-configs/blob/master/lib/flake.nix

{ self
, nixpkgs
, nix-darwin
, home
, flake-utils
, deploy-rs
, sops-nix
, nixos-modules
, nixvim
, simple-nixos-mailserver
, nur
, ...
}@inputs:

let inherit (flake-utils.lib) eachDefaultSystem mkApp;
in {
  mkGHActionsYAMLs = names:
    eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        mkGHActionsYAML = name:
          let
            file = import (../actions/${name}.nix);
            json = builtins.toJSON file;
          in
          pkgs.runCommand name { } ''
            mkdir -p $out
            echo ${
              pkgs.lib.escapeShellArg json
            } | ${pkgs.yj}/bin/yj -jy > $out/${name}.yml
          '';
        ghActionsYAMLs = (map mkGHActionsYAML names);
      in
      {
        apps.githubActions = mkApp {
          drv = pkgs.writeShellScriptBin "generate-gh-actions" ''
            for dir in ${builtins.toString ghActionsYAMLs}; do
              cp -f $dir/*.yml .github/workflows/
            done
            echo Done!
          '';
          exePath = "/bin/generate-gh-actions";
        };
      });

  mkRunCmd =
    { name, text, deps ? pkgs: with pkgs; [ coreutils findutils nixpkgs-fmt ] }:
    eachDefaultSystem (system:
    let pkgs = import nixpkgs { inherit system; };
    in rec {
      packages.${name} = pkgs.writeShellApplication {
        inherit name text;
        runtimeInputs = (deps pkgs);
      };
      apps.${name} = mkApp {
        drv = packages.${name};
        exePath = "/bin/${name}";
      };
    });

  mkNixOSConfig =
    { hostname
    , system ? "x86_64-linux"
    , username ? "rayandrew"
    , nixosSystem ? nixpkgs.lib.nixosSystem
    , extraModules ? [ ]
    , deployConfigurations ? { }
    }: {
      nixosConfigurations.${hostname} = nixosSystem {
        inherit system;
        modules = [
          ../hosts/${hostname}
          nur.nixosModules.nur
          sops-nix.nixosModules.sops
          nixos-modules.nixosModule
          simple-nixos-mailserver.nixosModule
        ] ++ extraModules;
        specialArgs = {
          inherit system;
          flake = self;
        };
      };

      apps.${system} = {
        "nixosActivations/${hostname}" = mkApp {
          drv =
            self.outputs.nixosConfigurations.${hostname}.config.system.build.toplevel;
          exePath = "/activate";
        };

        "nixosVMs/${hostname}" =
          let pkgs = import nixpkgs { inherit system; };
          in mkApp {
            drv = pkgs.writeShellScriptBin "run-${hostname}-vm" ''
              env QEMU_OPTS="''${QEMU_OPTS:--cpu max -smp 4 -m 4096M -machine type=q35}" \
                ${
                  self.outputs.nixosConfigurations.${hostname}.config.system.build.vm
                }/bin/run-${hostname}-vm
            '';
            exePath = "/bin/run-${hostname}-vm";
          };
      };

      deploy.nodes.${hostname} = deployConfigurations // {
        hostname = hostname;

        profiles.system = {
          user = "root";
          path = deploy-rs.lib.${system}.activate.nixos
            self.nixosConfigurations.${hostname};
        };
      };
    };

  mkDarwinConfig =
    { hostname
    , system ? "x86_64-darwin"
    , darwinSystem ? nix-darwin.lib.darwinSystem
    , extraModules ? [ ]
    }: {
      darwinConfigurations.${hostname} = darwinSystem {
        inherit system;
        modules = [
          ../hosts/${hostname}
        ] ++ extraModules;
        specialArgs = {
          inherit system;
          flake = self;
        };
      };

      apps.${system}."darwinActivations/${hostname}" = mkApp {
        drv = self.outputs.darwinConfigurations.${hostname}.system;
        exePath = "/activate";
      };
    };

  # https://github.com/nix-community/home-manager/issues/1510
  mkHomeConfig =
    { hostname
    , username ? "rayandrew"
    , homePath ? "/home"
    , configPosfix ? ".config/nix-config"
    , configuration ? ../home-manager
    , deviceType ? "desktop"
    , system ? "x86_64-linux"
    , homeManagerConfiguration ? home.lib.homeManagerConfiguration
    }:
    let
      pkgs = import nixpkgs {
        inherit system;
      };
      homeDirectory = "${homePath}/${username}";
    in
    {
      homeConfigurations.${hostname} = homeManagerConfiguration rec {
        inherit pkgs;
        modules = [
          ../overlays
          ({ ... }: {
            home = { inherit username homeDirectory; };
            imports = [ configuration ];
          })
          sops-nix.homeManagerModule
        ];
        extraSpecialArgs = {
          inherit system;
          flake = self;
          super = {
            device.type = deviceType;
            my-meta.username = username;
            my-meta.nixConfigPath = "${homeDirectory}/${configPosfix}";
            my-meta.projectsDirPath = "${homeDirectory}/Projects";
            my-meta.researchDirPath = "${homeDirectory}/Research";
          };
        };
      };

      apps.${system}."homeActivations/${hostname}" = mkApp {
        drv = self.outputs.homeConfigurations.${hostname}.activationPackage;
        exePath = "/activate";
      };
    };

  mkChecks = {}:
    let
      deploy-rs-checks = builtins.removeAttrs (builtins.mapAttrs (_: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib) [
        "aarch64-darwin" # not supported
      ];
    in
    {
      checks = deploy-rs-checks;
    };

  mkDeployConfig = {}: {
    deploy = {
      autoRollback = true;
      magicRollback = true;
      # fastConnection = true;
      # remoteBuild = true;
    };
  };

  mkDevShell = {}:
    eachDefaultSystem (system:
      let pkgs = import nixpkgs { inherit system; };
      in rec {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs;
            [
              # NixOS deployment tool
              deploy-rs.defaultPackage.${system}
            ];
        };
      });
}
