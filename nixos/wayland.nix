{ pkgs
, ...
}:

{
  programs.sway = {
    enable = true;
    extraPackages = [ ];
  };

  programs.xwayland = {
    enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      # xdg-desktop-portal-wlr
    ];
    # gtkUsePortal = true;
    wlr.enable = true;
  };
}
