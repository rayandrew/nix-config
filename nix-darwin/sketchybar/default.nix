{ config, lib, pkgs, ... }:

let
  barSize = "36";
  fontSize = "14";
  # for ayu light
  # barBackground = "fafafa";
  # barForeground = "575F66";
  # for everforest
  # barBackground = "2b3339";
  # barForeground = "dfad81";
  # for gruvbox
  barBackground = "282828";
  barForeground = "ebdbb2";

  scripts = ./scripts;
in
{
  environment.systemPackages = with pkgs; [ ];

  services.sketchybar = {
    enable = true;
    package = pkgs.sketchybar;
    config = builtins.readFile (pkgs.parseTemplate "sketchybar-config" ./config.sh {
      inherit barSize fontSize barBackground barForeground scripts;
      yabai_spaces_file = config.yabai_spaces_file;
    });
  };

  launchd.user.agents.sketchybar.environment = {
    FOREGROUND = "0xff${barForeground}";
    BACKGROUND = "0xff${barBackground}";
  };

  launchd.user.agents.sketchybar.serviceConfig.ThrottleInterval = 30;
  launchd.user.agents.sketchybar.serviceConfig.EnvironmentVariables.PATH =
    lib.mkForce
      "${config.services.sketchybar.package}/bin:${config.my-meta.systemPath}";

  launchd.user.agents.sketchybar.serviceConfig = {
    StandardErrorPath = "/tmp/sketchybar.err.log";
    StandardOutPath = "/tmp/sketchybar.out.log";
  };

  services.yabai.config.external_bar = "main:${barSize}:4";
  system.defaults.NSGlobalDomain._HIHideMenuBar = true; # show menu bar
}
