{ flake
, system
, lib
, platforms
, ...
}:

let
  inherit (flake) inputs;
in
{
  nixpkgs.overlays = [
    inputs.deadnix.overlays.default
    inputs.rust-overlay.overlays.default
    inputs.emacs-overlay.overlays.default
    inputs.nur.overlay
    # inputs.nixpkgs-wayland.overlay
    (final: prev:
      let
        template = prev.callPackage ../packages/template { };
        firefox-darwin = inputs.firefox-darwin.overlay final prev;
        vivaldi-darwin = prev.callPackage ../packages/vivaldi-darwin { };
        brave-darwin = prev.callPackage ../packages/brave-darwin { };
        thorium = prev.callPackage ../packages/thorium { };
      in
      rec {
        inherit (template) parseTemplate
          parseTemplateWithOut
          parseTemplateDir;

        lib = prev.lib.extend
          (_: _: (import ../lib {
            inherit (prev) lib config;
            inherit flake;
            pkgs = final;
          }));

        unstable = import inputs.nixpkgs {
          inherit system;
          config = prev.config;
        };

        stable = import inputs.stable {
          inherit system;
          config = prev.config;
        };

        # master = import inputs.master {
        #   inherit system;
        #   config = prev.config;
        # };

        gdb =
          if (final.stdenv.isDarwin) then
            (prev.gdb.overrideAttrs (finalAttrs: prevAttrs: {
              meta.platforms = prevAttrs.meta.platforms ++ [ "x86_64-darwin" "aarch64-darwin" ];
            })) else prev.gdb;

        jetbrains-mono-nerdfont =
          prev.nerdfonts.override { fonts = [ "JetBrainsMono" ]; };

        nix-cleanup = prev.callPackage ../packages/nix-cleanup { };
        nixos-cleanup = prev.callPackage ../packages/nix-cleanup { isNixOS = true; };
        nix-whereis = prev.callPackage ../packages/nix-whereis { };
        nixpkgs-review =
          if (prev.stdenv.isLinux) then
            final.unstable.nixpkgs-review.override { withSandboxSupport = true; }
          else
            final.unstable.nixpkgs-review;

        nvchad = prev.callPackage ../packages/nvchad { };

        sf-symbols = final.sf-symbols-minimal;
        sf-symbols-app = prev.callPackage ../packages/sf-symbols {
          app = true;
          fonts = false;
        };
        sf-symbols-full =
          prev.callPackage ../packages/sf-symbols { full = true; };
        sf-symbols-minimal = prev.callPackage ../packages/sf-symbols { };
        sf-mono-liga = prev.callPackage ../packages/sf-mono-liga { inherit flake; };
        sketchybar-app-font = prev.callPackage ../packages/sketchybar-app-font { };

        sketchyvim = prev.callPackage ../packages/sketchyvim { };

        # cargo
        cargo-leptos = prev.callPackage ../packages/cargo-leptos { };
        spotify-player = prev.callPackage ../packages/spotify-player { };
        gitui = prev.callPackage ../packages/gitui { };

        scripts = prev.callPackage ../packages/scripts { }; # own scripts


        ctpv = prev.callPackage ../packages/ctpv { };

        firefox-bin =
          if prev.stdenv.isDarwin then firefox-darwin.firefox-bin
          else prev.firefox-bin;

        firefox-devedition-bin =
          if prev.stdenv.isDarwin then firefox-darwin.firefox-devedition-bin
          else prev.firefox-devedition-bin;

        firefox-beta-bin =
          if prev.stdenv.isDarwin then firefox-darwin.firefox-beta-bin
          else prev.firefox-beta-bin;

        pdfannots2json = prev.callPackage ../packages/pdfannots2json { };

        vivaldi-cross =
          if prev.stdenv.isDarwin then vivaldi-darwin
          else final.vivaldi;

        brave-cross =
          if prev.stdenv.isDarwin then brave-darwin
          else final.brave;

        yabai-master-stack-plugin = prev.callPackage ../packages/yabai-master-stack-plugin { };

        felixkratz-sketchybar-helper = prev.callPackage ../packages/felixkratz-sketchybar-helper { };
        felixkratz-yabai = prev.callPackage ../packages/felixkratz-yabai { };
        sketchybar = prev.sketchybar.overrideAttrs (oldAttrs: {
          buildInputs = oldAttrs.buildInputs ++ [ final.darwin.apple_sdk.frameworks.IOKit final.darwin.apple_sdk.frameworks.CoreWLAN ];
        });

        # ML
        alpaca-cpp = prev.callPackage ../packages/alpaca-cpp { };

        zowie = prev.callPackage ../packages/zowie { };

        cherrytree-darwin = prev.callPackage ../packages/cherrytree-darwin { };

        thorium-darwin = thorium.thorium-darwin;

        change-res = prev.callPackage ../packages/change-res { };
      })
  ];
}
