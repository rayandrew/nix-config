{ config, lib, pkgs, ... }:

let
  scripts = ./scripts;
in
if builtins.hasAttr "hm" lib then
{
  home.activation.sketchybar = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ${pkgs.skhd}/bin/sketchybar --update || ${pkgs.killall}/bin/killall sketchybar || true
    touch /tmp/dynamic-island-cache
  '';
}
else 
{
  environment.systemPackages = with pkgs; [ 
    sketchybar-helper 
    sketchybar-island-helper 
    ifstat-legacy
  ];

  services.sketchybar = {
    enable = true;
    package = pkgs.sketchybar;
    config = ''
      #!/usr/bin/env bash

      source "${scripts}/colors.sh" # Loads all defined colors
      source "${scripts}/icons.sh"  # Loads all defined icons

      SKETCHYBAR_DIR="${scripts}"
      SKETCHYBAR_ITEMS_DIR="${scripts}/items"
      SKETCHYBAR_PLUGINS_DIR="${scripts}/plugins"
      DYNAMIC_ISLAND_DIR="${pkgs.sketchybar-island-helper}"

      # ITEM_DIR="${scripts}/items" # Directory where the items are configured
      # PLUGIN_DIR="${scripts}/plugins"
      # DYNAMIC_ISLAND_DIR="${pkgs.sketchybar-island-helper}"

      SPACE_CLICK_SCRIPT="yabai -m space --focus \$SID 2>/dev/null" # The script that is run for clicking on space components

      # helper process
      HELPER=git.felix.helper
      ${pkgs.killall}/bin/killall sketchybar-helper
      ${pkgs.sketchybar-helper}/bin/sketchybar-helper $HELPER &

      # Define Dynamic island custom configs here
      USER_CONFIG="${scripts}/userconfig.sh"
      test -f $USER_CONFIG && source $USER_CONFIG

      source "${pkgs.sketchybar-island-helper}/config.sh" # Loads Dynamic-Island config

      # run helper program
      ISLANDHELPER=git.crissnb.islandhelper
      ${pkgs.killall}/bin/killall islandhelper
      ${pkgs.sketchybar-island-helper}/helper/islandhelper $ISLANDHELPER &

      # Set up your own custom sketchybar config here
      ###############################################

      FONT="SF Pro"

      sketchybar --bar color=$BAR_COLOR \
	margin=0 \
	position=top \
	corner_radius=0

      source "$SKETCHYBAR_ITEMS_DIR/spaces.sh"
      source "$SKETCHYBAR_ITEMS_DIR/front-app.sh"
      source "$SKETCHYBAR_ITEMS_DIR/power.sh"
      source "$SKETCHYBAR_ITEMS_DIR/calendar.sh"
      source "$SKETCHYBAR_ITEMS_DIR/cpu.sh"
      source "$SKETCHYBAR_ITEMS_DIR/network.sh"

      source "$DYNAMIC_ISLAND_DIR/item.sh" # Loads Dynamic-Island item

      sketchybar --update
    '';
  };

  launchd.user.agents.sketchybar.environment = {
    # SHELL = "/bin/sh";
    SKETCHYBAR_DIR = "${scripts}";
    SKETCHYBAR_ITEMS_DIR = "${scripts}/items";
    SKETCHYBAR_PLUGINS_DIR = "${scripts}/plugins";
    DYNAMIC_ISLAND_DIR = "${pkgs.sketchybar-island-helper}";
  };

  launchd.user.agents.sketchybar.serviceConfig.EnvironmentVariables.PATH =
    lib.mkForce "${config.services.sketchybar.package}/bin:${config.my.systemPath}";

  # launchd.user.agents.sketchybar.serviceConfig = {
  #   StandardErrorPath = "/tmp/sketchybar.err.log";
  #   StandardOutPath = "/tmp/sketchybar.out.log";
  # };

  services.yabai.config.external_bar = "main:32:0";
  system.defaults.NSGlobalDomain._HIHideMenuBar = true; # hide menu bar
}
