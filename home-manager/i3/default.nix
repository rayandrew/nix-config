{ pkgs
, lib
, config
, ...
}:

let
  alt = "Mod1";
  modifier = "Mod4";
  term = "kitty";
  barName = "default";
  light = "light";

  commonOptions =
    let
      dunstctl = "${pkgs.dunst}/bin/dunstctl";
      screenShotName = with config.xdg.userDirs;
        "${pictures}/$(${pkgs.coreutils}/bin/date +%Y-%m-%d_%H-%M-%S)-screenshot.png";
    in
    import ../i3/common.nix rec {
      inherit config lib modifier alt dunstctl;
      browser = "firefox";
      # bars = [{ command = "${config.programs.waybar.package}/bin/waybar"; }];
      fileManager = "${terminal} ${config.programs.nnn.finalPackage}/bin/nnn -a -P p";
      menu = "${config.programs.rofi.package}/bin/rofi";
      # light needs to be installed in system, so not defining a path here
      light = "light";
      pamixer = "${pkgs.pamixer}/bin/pamixer";
      playerctl = "${pkgs.playerctl}/bin/playerctl";
      terminal = "${config.programs.kitty.package}/bin/kitty";

      fullScreenShot = ''

      '';
      areaScreenShot = ''

      '';

      extraBindings = {
        "${modifier}+p" = ''mode "${displayLayoutMode}"'';
      };

      extraModes = { };

      extraConfig = ''
        hide_edge_borders --i3 smart
      '';
    };

in
{
  xsession = {
    enable = true;
    windowManager.i3 = with commonOptions; {
      enable = true;
      package = pkgs.i3-gaps;
      config = {
        inherit config extraConfig;
      };
    };
  };
}
