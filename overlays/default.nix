{ pkgs, lib, flake, system, ... }:

let inherit (flake) inputs;
in {
  nixpkgs.overlays = [
    inputs.deadnix.overlays.default
    (final: prev: rec {
      lib = prev.lib.extend
        (finalLib: prevLib: (import ../lib { inherit (prev) lib config; }));

      jetbrains-mono-nerdfont =
        prev.nerdfonts.override { fonts = [ "JetBrainsMono" ]; };

      nix-whereis = prev.callPackage ../packages/nix-whereis { };
      nixpkgs-review =
        if (prev.stdenv.isLinux) then
          prev.nixpkgs-review.override { withSandboxSupport = true; }
        else
          prev.nixpkgs-review;

      sf-symbols = final.sf-symbols-minimal;
      sf-symbols-app = prev.callPackage ../packages/sf-symbols {
        app = true;
        fonts = false;
      };
      sf-symbols-full =
        prev.callPackage ../packages/sf-symbols { full = true; };
      sf-symbols-minimal = prev.callPackage ../packages/sf-symbols { };

      scripts = prev.callPackage ../packages/scripts { }; # own scripts

      sketchybar-shendy = prev.callPackage ../packages/sketchybar-shendy { };
    })
  ];
}
