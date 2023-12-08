{ config
, lib
, pkgs
, ...
}:


let
  inherit (config.my-meta) username;
  mod = "lalt";
  scripts = ./scripts;
  yabai = "${pkgs.yabai}/bin/yabai";
  term = "open -n -a ${pkgs.iterm2}/Applications/iterm2.app";
  editor = "open -n -a ${pkgs.emacs-unstable}/Applications/Emacs.app";
  # term = "open -n -a ${pkgs.kitty}/Applications/kitty.app --args";
  # term = "${pkgs.unstable.wezterm}/bin/wezterm start --always-new-process --";
  # term = "${wezterm} --";
in
{
  services.skhd = {
    enable = true;
    package = pkgs.skhd;
    skhdConfig = ''
      # Open applications
      # ${mod} - return: ${term}
      # ${mod} - e: ${editor}

      # lctrl + lshift - left  : yabai -m space --focus prev
      # lctrl + lshift - right : yabai -m space --focus next
      # lctrl - z              : yabai -m space --focus recent

      # ${mod} - 1 : yabai -m space --focus 1
      # ${mod} - 2 : yabai -m space --focus 2
      # ${mod} - 3 : yabai -m space --focus 3
      # ${mod} - 4 : yabai -m space --focus 4
      # ${mod} - 5 : yabai -m space --focus 5
      # ${mod} - 6 : yabai -m space --focus 6
      # ${mod} - 7 : yabai -m space --focus 7
      # ${mod} - 8 : yabai -m space --focus 8
      # ${mod} - 9 : yabai -m space --focus 9
      # ${mod} - 0 : yabai -m space --focus 10

      # ${mod} + shift - 1 : skhd -k "escape"; sh ${scripts}/move-window.sh 1
      # ${mod} + shift - 2 : skhd -k "escape"; sh ${scripts}/move-window.sh 2
      # ${mod} + shift - 3 : skhd -k "escape"; sh ${scripts}/move-window.sh 3
      # ${mod} + shift - 4 : skhd -k "escape"; sh ${scripts}/move-window.sh 4
      # ${mod} + shift - 5 : skhd -k "escape"; sh ${scripts}/move-window.sh 5
      # ${mod} + shift - 6 : skhd -k "escape"; sh ${scripts}/move-window.sh 6
      # ${mod} + shift - 7 : skhd -k "escape"; sh ${scripts}/move-window.sh 7
      # ${mod} + shift - 8 : skhd -k "escape"; sh ${scripts}/move-window.sh 8
      # ${mod} + shift - 9 : skhd -k "escape"; sh ${scripts}/move-window.sh 9
      # ${mod} + shift - 0 : skhd -k "escape"; sh ${scripts}/move-window.sh 10

      # # Window Navigation (through display borders): lalt - {h, j, k, l}
      # ${mod} - h    : yabai -m window --focus west  || yabai -m display --focus west
      # ${mod} - j    : yabai -m window --focus south || yabai -m display --focus south
      # ${mod} - k    : yabai -m window --focus north || yabai -m display --focus north
      # ${mod} - l    : yabai -m window --focus east  || yabai -m display --focus east
      # # ${mod} - left    : yabai -m window --focus west  || yabai -m display --focus west
      # # ${mod} - down    : yabai -m window --focus south || yabai -m display --focus south
      # # ${mod} - up      : yabai -m window --focus north || yabai -m display --focus north
      # # ${mod} - right   : yabai -m window --focus east  || yabai -m display --focus east

      # # window swapping
      # ${mod} + shift - h    : yabai -m window --swap west
      # ${mod} + shift - j    : yabai -m window --swap south
      # ${mod} + shift - k    : yabai -m window --swap north
      # ${mod} + shift - l    : yabai -m window --swap east

      # # Make window zoom to fullscreen: mod - \
      # ${mod} - 0x2A : yabai -m window --toggle zoom-fullscreen; sketchybar --trigger window_focus
      # # Make window zoom to parent node: mod + shift - \
      # ${mod} + shift - 0x2A : yabai -m window --toggle zoom-parent; sketchybar --trigger window_focus

      # # floating window
      # ${mod} - space : yabai -m window --toggle float --grid 5:5:1:1:5:5; sketchybar --trigger window_focus

      # # fill screen
      # ${mod} - o : yabai -m window --grid 1:1:0:0:1:1

      # # toggle stack
      # ${mod} - s : yabai -m space --layout "$(yabai -m query --spaces --space | jq -r 'if .type == "bsp" then "stack" else "bsp" end')"

      # # Toggle split orientation of the selected windows node: shift + lalt - s
      # ${mod} + shift - s : yabai -m window --toggle split

      # # Split
      # ${mod} - v : yabai -m config split_type vertical
      # ${mod} + shift - v : yabai -m config split_type horizontal
      # # lalt + lshift - space : yabai -m space --layout bsp && yabai -m balance

      # # go to next window
      # lctrl - right : yabai -m query --spaces --space \
      #   | ${pkgs.jq}/bin/jq -re ".index" \
      #   | xargs -I{} yabai -m query --windows --space {} \
      #   | ${pkgs.jq}/bin/jq -sre "add | map(select(.minimized != 1)) | sort_by(.display, .frame.y, .frame.y, .id) | reverse | nth(index(map(select(.\"has-focus\" == true))) - 1).id" \
      #   | xargs -I{} yabai -m window --focus {}

      # # go to prev window
      # lctrl - left: yabai -m query --spaces --space \
      #   | ${pkgs.jq}/bin/jq -re ".index" \
      #   | xargs -I{} yabai -m query --windows --space {} \
      #   | ${pkgs.jq}/bin/jq -sre "add | map(select(.minimized != 1)) | sort_by(.display, .frame.y, .frame.y, .id) | nth(index(map(select(.\"has-focus\" == true))) - 1).id" \
      #   | xargs -I{} yabai -m window --focus {}

      # # set insertion point in focused container
      # alt + ctrl - h : yabai -m window --insert west
      # alt + ctrl - j : yabai -m window --insert south
      # alt + ctrl - k : yabai -m window --insert north
      # alt + ctrl - l : yabai -m window --insert east
      # alt + ctrl - s : yabai -m window --insert stack

      # # (alt) set insertion point in focused container using arrows
      # alt + ctrl - left  : yabai -m window --insert west
      # alt + ctrl - down  : yabai -m window --insert south
      # alt + ctrl - up    : yabai -m window --insert north
      # alt + ctrl - right : yabai -m window --insert east

      # # Resize float
      # # make floating window fill screen
      # lctrl + lalt - up     : yabai -m window --grid 1:1:0:0:1:1
      # # make floating window fill left-third of screen
      # lctrl + lalt - left   : yabai -m window --grid 1:3:0:0:1:1
      # # make floating window fill right-third of screen
      # lctrl + lalt - right   : yabai -m window --grid 1:3:3:0:1:1
      # # make floating window fill two-third (middle) of screen
      # lctrl + lalt - down   : yabai -m window --grid 1:3:1:0:1:1

      # killall dock - when desktop transitions act weird
      # hyper - x : ${pkgs.killall}/bin/killall Dock
      # hyper - b : brew services restart sketchybar

      # :: resize @
      # lalt - r ; resize
      # resize < escape ; default
      # resize < q ; default
      # resize < h : yabai -m window --resize left:-20:0 || \
      #     yabai -m window --resize right:-20:0
      # resize < j : yabai -m window --resize top:0:20 || \
      #     yabai -m window --resize bottom:0:20
      # resize < k : yabai -m window --resize top:0:-20 || \
      #     yabai -m window --resize bottom:0:-20
      # resize < l : yabai -m window --resize left:20:0 || \
      #     yabai -m window --resize right:20:0
    '';
  };

  # launchd.user.agents.skhd.environment = {
  #   NIX_SSL_CERT_FILE = "/etc/ssl/certs/ca-certificates.crt";
  #   SHELL = "/bin/sh";
  # };

  launchd.user.agents.skhd.serviceConfig.EnvironmentVariables.PATH =
    lib.mkForce
      "${config.services.yabai.package}/bin:${config.services.skhd.package}/bin:${config.my-meta.systemPath}:${config.services.emacs.package}/bin";

  # launchd.user.agents.skhd.serviceConfig.ProgramArguments = lib.mkBefore [
  #   "/bin/sh -c"
  #   "wait4path /nix"
  #   "wait4path ${config.services.skhd.package}/bin/skhd"
  # ] ;

  # launchd.user.agents.skhd.serviceConfig.StartInterval = 30;
  # launchd.user.agents.skhd.serviceConfig.ThrottleInterval = 30;

  launchd.user.agents.skhd.serviceConfig = {
    StandardErrorPath = "/tmp/skhd.err.log";
    StandardOutPath = "/tmp/skhd.out.log";
  };

  # system.activationScripts.postActivation.text =
  #   let path = "${pkgs.skhd}/bin/skhd";
  #   in ''
  #     ${pkgs.sqlite}/bin/sqlite3 '/Library/Application Support/com.apple.TCC/TCC.db' \
  #       'INSERT or REPLACE INTO access VALUES("kTCCServiceAccessibility","${path}",1,2,4,1,NULL,NULL,0,NULL,NULL,0,NULL);
  #       DELETE from access where client_type = 1 and client != "${path}" and client like "%/bin/skhd";'
  #   '';
}
