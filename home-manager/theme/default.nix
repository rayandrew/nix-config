{ super, config, pkgs, lib, ... }:


{
  home = {
    pointerCursor = {
      package = pkgs.nordzy-cursor-theme;
      name = "Nordzy-cursors";
      size = 24;
      x11.enable = true;
      gtk.enable = true;
    };
  };
}
