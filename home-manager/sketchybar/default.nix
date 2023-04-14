{ config, lib, pkgs, ... }:

let

  inherit (config.my-meta) backgroundColor foregroundColor sketchybarSize;

  # barSize = "36";
  fontSize = "14";

  barBackground = "0xff" + (builtins.replaceStrings [ "#" ] [ "" ] backgroundColor);
  barForeground = "0xff" + (builtins.replaceStrings [ "#" ] [ "" ] foregroundColor);

  scripts = ./scripts;
  items = ./items;
in
{
  imports = [
    ../../modules/darwin/sketchybar
  ];

  home.packages = with pkgs; [
    felixkratz-sketchybar-helper
  ];

  services.sketchybar = {
    enable = true;
    package = pkgs.sketchybar;
    config = builtins.readFile (pkgs.parseTemplate "sketchybar-config" ./config.sh {
      inherit fontSize scripts barBackground barForeground sketchybarSize;
      helper = "${pkgs.felixkratz-sketchybar-helper}/bin/felixkratz-sketchybar-helper";
      # yabai_spaces_file = config.yabai_spaces_file;
    });
  };

  launchd.agents.sketchybar.config.EnvironmentVariables = {
    FOREGROUND = barForeground;
    BACKGROUND = barBackground;
    ITEMS_DIR = "${items}";
    SCRIPTS_DIR = "${scripts}";
    CONFIG_DIR = "${./.}";
    PATH =
      lib.mkForce
        "${config.services.sketchybar.package}/bin:${config.my-meta.systemPath}";
    HELPER = "git.rayandrew.helper";
  };

  # launchd.agents.sketchybar.config.ThrottleInterval = 30;
  launchd.agents.sketchybar.config = {
    StandardErrorPath = "/tmp/sketchybar.err.log";
    StandardOutPath = "/tmp/sketchybar.out.log";
  };

  # services.yabai.config.external_bar = "all:${barSize}:4";
  # services.yabai.config.external_bar = "main:${barSize}:4";
  targets.darwin.defaults.NSGlobalDomain._HIHideMenuBar = lib.mkForce true; # show menu bar
}
