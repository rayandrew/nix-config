{ pkgs
, lib
, ...
}:

{
  xsession = {
    enable = true;
    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
    };
  };

  home.packages = with pkgs; [
    dmenu #application launcher most people use
    i3status-rust
    i3-gaps
    i3lock-fancy
    rofi
  ];
}
