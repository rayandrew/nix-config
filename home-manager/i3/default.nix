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

  commonOptions =
    let
      dunstctl = "${pkgs.dunst}/bin/dunstctl";
      rofi = "${config.programs.rofi.package}/bin/rofi";
      mons = "${pkgs.mons}/bin/mons";
      screenShotName = with config.xdg.userDirs;
        "${pictures}/$(${pkgs.coreutils}/bin/date +%Y-%m-%d_%H-%M-%S)-screenshot.png";
      displayLayoutMode =
        " : [h]  , [j]  , [k]  , [l]  , [a]uto, [d]uplicate, [m]irror, [s]econd-only, primary-[o]nly";
    in
    import ./common.nix rec {
      inherit config lib modifier alt dunstctl;

      browser = "firefox";
      fileManager = "${terminal} ${config.programs.nnn.finalPackage}/bin/nnn -a -P p";
      statusCommand = with config;
        "${programs.i3status-rust.package}/bin/i3status-rs ${xdg.configHome}/i3status-rust/config-i3.toml";
      menu = "${rofi} -show drun";
      # light needs to be installed in system, so not defining a path here
      light = "light";
      pamixer = "${pkgs.pamixer}/bin/pamixer";
      playerctl = "${pkgs.playerctl}/bin/playerctl";
      terminal =
        if config.programs.kitty.enable then
          "${config.programs.kitty.package}/bin/kitty"
        else
          "${pkgs.xterm}/bin/xterm";

      # Screenshots
      fullScreenShot = ''
        ${pkgs.maim}/bin/maim -u "${screenShotName}" && \
        ${pkgs.libnotify}/bin/notify-send -u normal -t 5000 'Full screenshot taken'
      '';
      areaScreenShot = ''
        ${pkgs.maim}/bin/maim -u -s "${screenShotName}" && \
        ${pkgs.libnotify}/bin/notify-send -u normal -t 5000 'Area screenshot taken'
      '';

      extraBindings = {
        "${modifier}+p" = ''mode "${displayLayoutMode}"'';
        "${modifier}+c" =
          "exec ${rofi} -show calc -modi calc -no-show-match -no-sort";
        "${modifier}+Tab" = "exec ${rofi} -show window -modi window";
      };

      extraModes = with commonOptions.helpers; let
        runMons = action:
          "mode default, exec ${mons} ${action} && systemctl --user restart wallpaper.service";
      in
      {
        ${displayLayoutMode} = (mapDirection {
          leftCmd = runMons "-e left";
          downCmd = runMons "-e bottom";
          upCmd = runMons "-e top";
          rightCmd = runMons "-e right";
        }) // {
          a = "mode default, exec ${pkgs.change-res}/bin/change-res";
          d = runMons "-d";
          m = runMons "-m";
          s = runMons "-s";
          o = runMons "-o";
          "Escape" = "mode default";
          "Return" = "mode default";
        };
      };

      extraConfig = ''
      '';
    };

in
{
  imports = [ ./dunst.nix ];

  xsession = {
    enable = true;
    windowManager.i3 = with commonOptions; {
      enable = true;
      package = pkgs.i3-gaps;
      inherit extraConfig;
      config = commonOptions.config;
    };
  };
}
