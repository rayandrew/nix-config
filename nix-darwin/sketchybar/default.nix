{ config, lib, pkgs, ... }:

let
  barSize = "32";
  fontSize = "12";
  barBackground = "16161e";
  barForeground = "a9b1d6";
  configs = ./configs;
in
if builtins.hasAttr "hm" lib then {
  home.activation.sketchybar = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ${pkgs.skhd}/bin/sketchybar --update || ${pkgs.killall}/bin/killall sketchybar || true
    # touch /tmp/dynamic-island-cache
  '';
} else {
  environment.systemPackages = with pkgs; [ ];

  services.sketchybar = {
    enable = true;
    package = pkgs.sketchybar;
    config = ''
      #!/usr/bin/env sh

      source "${configs}/color.sh"

      PLUGIN_DIR="${configs}/controller"
      PLUGIN_TOUCH="${configs}/controller/touch"
      ITEM_DIR="${configs}/view"

      PADDING=4
      ICON="SF Symbols"
      LABEL="JetBrainsMono Nerd Font Mono"

      sketchybar --bar height=${barSize}                   \
      blur_radius=0                                        \
      padding_left=4                                       \
      padding_right=4                                      \
      color=0xff${barBackground}                           \
      position=bottom                                      \
      sticky=on                                            \
      font_smoothing=on                                    \
                                                           \
      --default updates=when_shown                         \
      drawing=on                                           \
      icon.font="$ICON:SemiBold:${fontSize}.0"             \
      label.font="$LABEL:SemiBold:${fontSize}.0"           \
      icon.padding_left=$PADDING                           \
      icon.padding_right=$PADDING                          \
      label.padding_left=$PADDING                          \
      label.padding_right=$PADDING                         \
      label.color=0xff${barForeground}                     \
      icon.color=0xff${barForeground}                      \


      # left
      source "$ITEM_DIR/space.sh"
      source "$ITEM_DIR/front_app.sh"

      # right
      source "$ITEM_DIR/battery.sh"
      source "$ITEM_DIR/disk.sh"
      source "$ITEM_DIR/mem.sh"
      source "$ITEM_DIR/cpu.sh"

      # initializing
      sketchybar --update

      echo "sketchybar configuration loaded.." 
    '';
  };

  launchd.user.agents.sketchybar.environment = {
    PLUGIN_DIR = "${configs}/controller";
    PLUGIN_TOUCH = "${configs}/controller/touch";
    ITEM_DIR = "${configs}/view";
  };

  launchd.user.agents.sketchybar.serviceConfig.ThrottleInterval = 30;
  launchd.user.agents.sketchybar.serviceConfig.EnvironmentVariables.PATH =
    lib.mkForce
      "${config.services.sketchybar.package}/bin:${config.my-meta.systemPath}";

  launchd.user.agents.sketchybar.serviceConfig = {
    StandardErrorPath = "/tmp/sketchybar.err.log";
    StandardOutPath = "/tmp/sketchybar.out.log";
  };

  services.yabai.config.external_bar = "main:4:4";
  system.defaults.NSGlobalDomain._HIHideMenuBar = false; # show menu bar
}
