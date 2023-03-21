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
  separator = id: position: ''
    sketchybar --add item ${id} ${position} \
      --set ${id} icon= \
      icon.padding_left=0 \
      icon.padding_right=0 \
      background.padding_left=0 \
      background.padding_right=0 \
      icon.align=center
  '';
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

      # Unload the macOS on screen indicator overlay for volume change
      launchctl unload -F /System/Library/LaunchAgents/com.apple.OSDUIHelper.plist > /dev/null 2>&1 & 

      PADDING=4
      ICON="Liga SFMono Nerd Font"
      LABEL="Liga SFMono Nerd Font"

      sketchybar -m --add event window_created \
                    --add event window_destroyed

      sketchybar --bar height=${barSize}                                       \
                       blur_radius=0                                           \
                       color=0xff${barBackground}                              \
                       position=top                                            \
                       sticky=on                                               \
                       font_smoothing=on                                       \
                 --default updates=when_shown                                  \
                           drawing=on                                          \
                           icon.padding_left=$PADDING                          \
                           icon.padding_right=$PADDING                         \
                           label.padding_left=$PADDING                         \
                           label.padding_right=$PADDING                        \
                           icon.font="$ICON:Bold:${fontSize}.0"                \
                           label.font="$LABEL:Regular:${fontSize}.0"           \
                           label.color=0xff${barForeground}                    \
                           icon.color=0xff${barForeground}                      

      sketchybar -m --add item yabai_spaces left \
       --set yabai_spaces drawing=off \
                          updates=on \
                          script="${scripts}/yabai_spaces.sh" \
       --subscribe yabai_spaces space_change window_created window_destroyed \
       --add item space_template left \
       --set space_template icon.highlight_color=0xff9dd274 \
             drawing=off \
             click_script="yabai -m space --focus \$NAME"

        sketchybar  --add item time right \
                    --set time update_freq=5 \
                          icon.drawing=off \
                          script="${scripts}/time.sh"

        ${separator "sep_right_0" "right"}

        sketchybar --add item battery right \
                   --subscribe battery system_woke \
                   --set battery update_freq=5 \
                         script="${scripts}/battery.sh"

        ${separator "sep_right_1" "right"}

        sketchybar -m --add item cpu right \
                      --set cpu update_freq=3 \
                            script="${scripts}/cpu.sh"

        ${separator "sep_right_2" "right"}

        sketchybar -m --add item disk right \
                      --set disk update_freq=10 \
                      script="${scripts}/disk.sh"

        ${separator "sep_right_3" "right"}

        sketchybar -m --add item ram right \
                      --set ram update_freq=5 \
                            script="${scripts}/mem.sh"

        ${separator "sep_right_4" "right"}

        # Title
        sketchybar --add item window_title right \
                   --set window_title script="${scripts}/window_title.sh" \
                                      icon.drawing=off \
                                      label.color=0xff${barForeground} \
                   --subscribe window_title front_app_switched  

        # initializing
        sketchybar --update
    '';
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
