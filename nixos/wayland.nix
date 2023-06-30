{ pkgs
, ...
}:

{
  programs.sway = {
    enable = true;
    extraPackages = [ ];
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];

    wlr.enable = true;
  };
}
