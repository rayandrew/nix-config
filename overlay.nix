self: super: rec {
  jetbrains-mono-nerdfont = super.nerdfonts.override { fonts = [ "JetBrainsMono" ]; };
  sf-symbols = self.sf-symbols-minimal;
  sf-symbols-app = super.callPackage ./pkgs/sf-symbols { app = true; fonts = false; };
  sf-symbols-full = super.callPackage ./pkgs/sf-symbols { full = true; };
  sf-symbols-minimal = super.callPackage ./pkgs/sf-symbols { };

  scripts = super.callPackage ./pkgs/scripts { }; # own scripts

  sketchybar-helper = super.callPackage ./pkgs/sketchybar-helper { };
  sketchybar-island-helper = super.callPackage ./pkgs/sketchybar-island-helper { };
  sketchybar-shendy = super.callPackage ./pkgs/sketchybar-shendy { };
}
