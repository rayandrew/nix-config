{ config, lib, pkgs, ... }:

let
  scripts = ./scripts;
in
if builtins.hasAttr "hm" lib then
{
  home.activation.sketchybar = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ${pkgs.killall}/bin/killall sketchybar || true
  '';

  programs.bash.initExtra = ''
    export SKETCHYBAR_DIR="${scripts}"
    export SKETCHYBAR_ITEMS_DIR="${scripts}/items"
    export SKETCHYBAR_PLUGINS_DIR="${scripts}/plugins"
    export DYNAMIC_ISLAND_DIR="${pkgs.sketchybar-island-helper}"  
  '';
}
else 
{
  environment.systemPackages = with pkgs; [ 
    sketchybar-helper 
    sketchybar-island-helper 
    ifstat-legacy
  ];

  environment.variables = {
    SKETCHYBAR_DIR = "${scripts}";
    SKETCHYBAR_ITEMS_DIR = "${scripts}/items";
    SKETCHYBAR_PLUGINS_DIR = "${scripts}/plugins";
    DYNAMIC_ISLAND_DIR = "${pkgs.sketchybar-island-helper}";
  };

  programs.bash.interactiveShellInit = ''
    export SKETCHYBAR_DIR="${scripts}"
    export SKETCHYBAR_ITEMS_DIR="${scripts}/items"
    export SKETCHYBAR_PLUGINS_DIR="${scripts}/plugins"
    export DYNAMIC_ISLAND_DIR="${pkgs.sketchybar-island-helper}"
  '';

  services.sketchybar = {
    enable = true;
    package = pkgs.sketchybar;
    config = ''
      #!/usr/bin/env sh

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
      HELPER=git.rayandrew.helper
      ${pkgs.killall}/bin/killall sketchybar-helper
      ${pkgs.sketchybar-helper}/bin/sketchybar-helper $HELPER &

      # Define Dynamic island custom configs here
      USER_CONFIG="${scripts}/userconfig.sh"
      test -f $USER_CONFIG && source $USER_CONFIG

      PADDINGS=3

      # Setting up the general bar appearance and default values
      sketchybar --bar height=32 \
        color=$P_DYNAMIC_ISLAND_COLOR_TRANSPARENT \
	shadow=off \
	position=top \
	sticky=on \
	padding_right=$((10 - $PADDINGS)) \
	topmost=$\{P_DYNAMIC_ISLAND_TOPMOST:=off} \
	padding_left=18 \
	corner_radius=9 \
	y_offset=0 \
	margin=10 \
	blur_radius=30 \
	notch_width=0 \
	--default updates=when_shown \
	icon.font="$P_DYNAMIC_ISLAND_FONT:Bold:14.0" \
	icon.color=$P_DYNAMIC_ISLAND_COLOR_WHITE \
	icon.padding_left=$PADDINGS \
	icon.padding_right=$PADDINGS \
	label.font="$P_DYNAMIC_ISLAND_FONT:Semibold:13.0" \
	label.color=$P_DYNAMIC_ISLAND_COLOR_WHITE \
	label.padding_left=$PADDINGS \
	label.padding_right=$PADDINGS \
	background.padding_right=$PADDINGS \
	background.padding_left=$PADDINGS \
	popup.background.corner_radius=11 \
	popup.background.shadow.drawing=off \
	popup.background.border_width=2 \
	popup.horizontal=on
      # source "$DYNAMIC_ISLAND_DIR/config.sh" # Loads Dynamic-Island config

      # run helper program
      ISLANDHELPER=git.rayandrew.islandhelper
      ${pkgs.killall}/bin/killall island-helper
      ${pkgs.sketchybar-island-helper}/bin/island-helper $ISLANDHELPER &

      # Set up your own custom sketchybar config here
      ###############################################

      FONT="SF Pro"

      sketchybar --bar color=$BAR_COLOR \
	margin=0 \
	corner_radius=0

      source "$SKETCHYBAR_ITEMS_DIR/spaces.sh" $SKETCHYBAR_DIR
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
    SHELL = "/bin/bash";
    SKETCHYBAR_DIR = "${scripts}";
    SKETCHYBAR_ITEMS_DIR = "${scripts}/items";
    SKETCHYBAR_PLUGINS_DIR = "${scripts}/plugins";
    DYNAMIC_ISLAND_DIR = "${pkgs.sketchybar-island-helper}";
  };

  launchd.user.agents.sketchybar.serviceConfig.EnvironmentVariables.PATH =
    lib.mkForce "${config.services.sketchybar.package}/bin:${config.my.systemPath}";

  launchd.user.agents.sketchybar.serviceConfig = {
    StandardErrorPath = "/tmp/sketchybar.err.log";
    StandardOutPath = "/tmp/sketchybar.out.log";
  };

  services.yabai.config.external_bar = "main:24:0";
  system.defaults.NSGlobalDomain._HIHideMenuBar = true; # hide menu bar
}
