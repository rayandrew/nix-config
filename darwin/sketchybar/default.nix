{ config, lib, pkgs, ... }:

let
  barSize = "32";
  fontSize = "12";
in
if builtins.hasAttr "hm" lib then
{
  home.activation.sketchybar = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ${pkgs.skhd}/bin/sketchybar --update || ${pkgs.killall}/bin/killall sketchybar || true
    # touch /tmp/dynamic-island-cache
  '';
}
else 
{
  environment.systemPackages = with pkgs; [ 
    sketchybar-shendy
  ];

  services.sketchybar = {
    enable = true;
    package = pkgs.sketchybar;
    config = ''
      #!/usr/bin/env sh

      source "${pkgs.sketchybar-shendy}/color.sh"

      PLUGIN_DIR="${pkgs.sketchybar-shendy}/controller"
      PLUGIN_TOUCH="${pkgs.sketchybar-shendy}/controller/touch"
      ITEM_DIR="${pkgs.sketchybar-shendy}/view"

      PADDING=4
      ICON="SF Symbols"
      LABEL="JetBrainsMono Nerd Font Mono"

      sketchybar --bar     height=${barSize}                                            \
      blur_radius=0                                        \
      padding_left=4                                       \
      padding_right=4                                      \
      color=0xff''${NORD0:1}                                 \
      position=bottom                                      \
      sticky=on                                            \
      font_smoothing=on                                    \
      \
      --default updates=when_shown                                   \
      drawing=on                                           \
      icon.font="$ICON:SemiBold:${fontSize}.0"                      \
      label.font="$LABEL:SemiBold:${fontSize}.0"                    \
      icon.padding_left=$PADDING                           \
      icon.padding_right=$PADDING                          \
      label.padding_left=$PADDING                          \
      label.padding_right=$PADDING                         \
      label.color=0xff''${NORD6:1}                           \
      icon.color=0xff''${NORD6:1}                            \


      # left
      source "$ITEM_DIR/space.sh"
      source "$ITEM_DIR/front_app.sh"

      # right
      source "$ITEM_DIR/time.sh"
      source "$ITEM_DIR/cal.sh"
      source "$ITEM_DIR/wifi.sh"
      source "$ITEM_DIR/mic.sh"
      source "$ITEM_DIR/battery.sh"
      source "$ITEM_DIR/airpodsbattery.sh"
      source "$ITEM_DIR/airpodscasebattery.sh"
      source "$ITEM_DIR/sound.sh"
      source "$ITEM_DIR/disk.sh"
      source "$ITEM_DIR/mem.sh"
      source "$ITEM_DIR/cpu.sh"

      # initializing
      sketchybar --update

      echo "sketchybar configuration loaded.." 
    '';
  };

  launchd.user.agents.sketchybar.environment = {
    PLUGIN_DIR = "${pkgs.sketchybar-shendy}/controller";
    PLUGIN_TOUCH = "${pkgs.sketchybar-shendy}/controller/touch";
    ITEM_DIR = "${pkgs.sketchybar-shendy}/view";
  };

  launchd.user.agents.sketchybar.serviceConfig.ThrottleInterval = 30;
  launchd.user.agents.sketchybar.serviceConfig.EnvironmentVariables.PATH =
    lib.mkForce "${config.services.sketchybar.package}/bin:${config.my.systemPath}";

  launchd.user.agents.sketchybar.serviceConfig = {
    StandardErrorPath = "/tmp/sketchybar.err.log";
    StandardOutPath = "/tmp/sketchybar.out.log";
  };

  services.yabai.config.external_bar = "main:4:4";
  system.defaults.NSGlobalDomain._HIHideMenuBar = false; # show menu bar
}
