{ flake, system, ... }:

let inherit (flake) inputs;
in {
  nixpkgs.overlays = [
    inputs.deadnix.overlays.default
    (final: prev: rec {
      lib = prev.lib.extend
        (_: _: (import ../lib { inherit (prev) lib config; }));

      unstable = import inputs.unstable {
        inherit system;
        config = prev.config;
      };

      jetbrains-mono-nerdfont =
        prev.nerdfonts.override { fonts = [ "JetBrainsMono" ]; };

      nix-whereis = prev.callPackage ../packages/nix-whereis { };
      nixpkgs-review =
        if (prev.stdenv.isLinux) then
          final.unstable.nixpkgs-review.override { withSandboxSupport = true; }
        else
          final.unstable.nixpkgs-review;


      sf-symbols = final.sf-symbols-minimal;
      sf-symbols-app = prev.callPackage ../packages/sf-symbols {
        app = true;
        fonts = false;
      };
      sf-symbols-full =
        prev.callPackage ../packages/sf-symbols { full = true; };
      sf-symbols-minimal = prev.callPackage ../packages/sf-symbols { };

      scripts = prev.callPackage ../packages/scripts { }; # own scripts
    })
  ];
}
