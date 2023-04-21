{ config, lib, pkgs, ... }:

let
  inherit (config.home) homeDirectory;
  inherit (config.my-meta) backgroundColor foregroundColor sketchybarSize;

  # barSize = "36";
  fontSize = "14";

  barBackground = "0xff" + (builtins.replaceStrings [ "#" ] [ "" ] backgroundColor);
  barForeground = "0xff" + (builtins.replaceStrings [ "#" ] [ "" ] foregroundColor);

  configDir = ./config;
  scriptsDir = ./config/scripts;
  itemsDir = ./config/items;
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
    config = (pkgs.parseTemplateDir "sketchybar-config" ./config {
      inherit fontSize barBackground barForeground sketchybarSize;
      # inherit configDir scriptsDir itemsDir;
      helper = "${pkgs.felixkratz-sketchybar-helper}/bin/felixkratz-sketchybar-helper";
    }).overrideAttrs (old: {
      buildPhase = ''
        ${old.buildPhase}
        find $out -type f -iname "*.sh" -exec chmod +x {} \;
        cd $out && chmod +x sketchybarrc
      '';
    });
    # config = builtins.readFile (pkgs.parseTemplate "sketchybar-config" ./config/config.sh {
    #   inherit fontSize barBackground barForeground sketchybarSize;
    #   inherit configDir scriptsDir itemsDir;
    #   helper = "${pkgs.felixkratz-sketchybar-helper}/bin/felixkratz-sketchybar-helper";
    #   # yabai_spaces_file = config.yabai_spaces_file;
    # });
  };

  launchd.agents.sketchybar.config.EnvironmentVariables = {
    FOREGROUND = barForeground;
    BACKGROUND = barBackground;
    ITEMS_DIR = "${homeDirectory}/.config/sketchybar/items";
    SCRIPTS_DIR = "${homeDirectory}/.config/sketchybar/scripts";
    CONFIG_DIR = "${homeDirectory}/.config/sketchybar";
    # ITEMS_DIR = "${itemsDir}";
    # SCRIPTS_DIR = "${scriptsDir}";
    # CONFIG_DIR = "${configDir}";
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
