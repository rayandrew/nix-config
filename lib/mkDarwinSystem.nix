inputs:

{ username, fullName, email, directory # directory on the system
, system ? "aarch64-darwin"

  # `nix-darwin` modules to include
, modules ? [ ]
  # Additional `nix-darwin` modules to include, useful when reusing a configuration with
  # `lib.makeOverridable`.
, extraModules ? [ ]

  # Value for `home-manager`'s `home.stateVersion` option.
, homeStateVersion
# `home-manager` modules to include
, homeModules ? [ ]
  # Additional `home-manager` modules to include, useful when reusing a configuration with
  # `lib.makeOverridable`.
, extraHomeModules ? [ ] }:

inputs.darwin.lib.darwinSystem {
  inherit system;
  modules = modules ++ extraModules ++ [
    inputs.home-manager.darwinModules.home-manager
    ({ config, ... }: {
      users.primaryUser = { inherit username fullName email directory; };

      # Support legacy workflows that use `<nixpkgs>` etc.
      nix.nixPath.nixpkgs = "${inputs.nixpkgs-unstable}";

      # `home-manager` config
      users.users.${username} = {
        home = "/Users/${username}";
        shell = inputs.nixpkgs-unstable.fish;
      };

      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.${username} = {
        imports = homeModules ++ extraHomeModules;
        home.stateVersion = homeStateVersion;
        home.user-info = config.users.primaryUser;
      };
    })
  ];
}
