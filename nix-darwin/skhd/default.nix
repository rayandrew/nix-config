{ config, lib, pkgs, ... }:

if builtins.hasAttr "hm" lib then {
  home.activation.skhd = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ${pkgs.skhd}/bin/skhd --reload || ${pkgs.killall}/bin/killall skhd || true
  '';
} else
  let
    scripts = ./scripts;
    yabai = "${pkgs.yabai}/bin/yabai";
  in
  {
    services.skhd = {
      enable = true;
      package = pkgs.skhd;
      skhdConfig = ''
        lctrl + lshift - left  : yabai -m space --focus prev
        lctrl + lshift - right : yabai -m space --focus next
        lctrl - z              : yabai -m space --focus recent

        lalt - 0 : yabai -m space --focus 1
        lalt - 1 : yabai -m space --focus 2
        lalt - 2 : yabai -m space --focus 3
        lalt - 3 : yabai -m space --focus 4
        lalt - 4 : yabai -m space --focus 5
        lalt - 5 : yabai -m space --focus 6
        lalt - 6 : yabai -m space --focus 7
        lalt - 7 : yabai -m space --focus 8
        lalt - 8 : yabai -m space --focus 9
        lalt - 9 : yabai -m space --focus 10
        lalt - z : yabai -m space --focus 11
        lalt - x : yabai -m space --focus 12
        lalt - c : yabai -m space --focus 13

        lalt + shift - 0 : skhd -k "escape"; sh ${scripts}/move-window.sh 1
        lalt + shift - 1 : skhd -k "escape"; sh ${scripts}/move-window.sh 2
        lalt + shift - 2 : skhd -k "escape"; sh ${scripts}/move-window.sh 3
        lalt + shift - 3 : skhd -k "escape"; sh ${scripts}/move-window.sh 4
        lalt + shift - 4 : skhd -k "escape"; sh ${scripts}/move-window.sh 5
        lalt + shift - 5 : skhd -k "escape"; sh ${scripts}/move-window.sh 6
        lalt + shift - 6 : skhd -k "escape"; sh ${scripts}/move-window.sh 7
        lalt + shift - 7 : skhd -k "escape"; sh ${scripts}/move-window.sh 8
        lalt + shift - 8 : skhd -k "escape"; sh ${scripts}/move-window.sh 9
        lalt + shift - 9 : skhd -k "escape"; sh ${scripts}/move-window.sh 10
        lalt + shift - 0 : skhd -k "escape"; sh ${scripts}/move-window.sh 11
        lalt + shift - z : skhd -k "escape"; sh ${scripts}/move-window.sh 12
        lalt + shift - x : skhd -k "escape"; sh ${scripts}/move-window.sh 13
        lalt + shift - c : skhd -k "escape"; sh ${scripts}/move-window.sh 14

        # Window Navigation (through display borders): lalt - {h, j, k, l}
        lalt - h    : yabai -m window --focus west  || yabai -m display --focus west
        lalt - j    : yabai -m window --focus south || yabai -m display --focus south
        lalt - k    : yabai -m window --focus north || yabai -m display --focus north
        lalt - l    : yabai -m window --focus east  || yabai -m display --focus east

        # Window Swapping
        lalt + shift - h    : yabai -m window --swap west
        lalt + shift - j    : yabai -m window --swap south
        lalt + shift - k    : yabai -m window --swap north 
        lalt + shift - l    : yabai -m window --swap east

        # Make window zoom to fullscreen: lalt - f
        lalt - f : yabai -m window --toggle zoom-fullscreen; sketchybar --trigger window_focus

        # Make window zoom to parent node: shift + lalt - f 
        shift + lalt - f : yabai -m window --toggle zoom-parent; sketchybar --trigger window_focus

        # Toggle split orientation of the selected windows node: shift + lalt - s
        shift + lalt - s : yabai -m window --toggle split

        # floating window
        lalt - space : yabai -m window --toggle float --grid 5:5:1:1:5:5; sketchybar --trigger window_focus
        # lalt - space : yabai -m window --toggle float; sketchybar --trigger window_focus

        # fill screen
        lalt - o : yabai -m window --grid 1:1:0:0:1:1

        # toggle stack
        lalt - s : yabai -m space --layout "$(yabai -m query --spaces --space | jq -r 'if .type == "bsp" then "stack" else "bsp" end')"

        # go to next window
        lctrl - right : yabai -m query --spaces --space \
          | ${pkgs.jq}/bin/jq -re ".index" \
          | xargs -I{} yabai -m query --windows --space {} \
          | ${pkgs.jq}/bin/jq -sre "add | map(select(.minimized != 1)) | sort_by(.display, .frame.y, .frame.y, .id) | reverse | nth(index(map(select(.\"has-focus\" == true))) - 1).id" \
          | xargs -I{} yabai -m window --focus {}

        # go to prev window
        lctrl - left: yabai -m query --spaces --space \
          | ${pkgs.jq}/bin/jq -re ".index" \
          | xargs -I{} yabai -m query --windows --space {} \
          | ${pkgs.jq}/bin/jq -sre "add | map(select(.minimized != 1)) | sort_by(.display, .frame.y, .frame.y, .id) | nth(index(map(select(.\"has-focus\" == true))) - 1).id" \
          | xargs -I{} yabai -m window --focus {}

        # killall dock - when desktop transitions act weird
        hyper - x : ${pkgs.killall}/bin/killall Dock
        hyper - b : brew services restart sketchybar

        # Open applications
        # lalt - return : open -n -a ${pkgs.kitty}/Applications/kitty.app
        # lalt + lshift - return : open -n -a ${pkgs.kitty}/Applications/kitty.app --args ${pkgs.zsh}/bin/zsh -c "${pkgs.tmux}/bin/tmux attach || ${pkgs.tmux}/bin/tmux"
        # lalt + lshift - return : open -n -a ${pkgs.kitty}/Applications/kitty.app --args --session ${scripts}/tmux-kitty.session
        lalt - return : ${pkgs.wezterm}/bin/wezterm start --always-new-process
        # lalt + shift - return : ${pkgs.wezterm}/bin/wezterm start --always-new-process -- zsh -l -c "tmux attach || tmux"
        lalt - e : open ~/
        lalt - n : open -n -a /Applications/Neovide.app --args --frame none
        lctrl - s: ${pkgs.wezterm}/bin/wezterm start --always-new-process -- spotify_player
        lctrl - m: ${pkgs.wezterm}/bin/wezterm start --always-new-process -- htop

        # rotate tree
        lalt + shift - r : yabai -m space --rotate 90

        :: resize @
        lalt - r ; resize
        resize < escape ; default
        resize < q ; default

        resize < h : yabai -m window --resize left:-20:0 || \
            yabai -m window --resize right:-20:0
        resize < l : yabai -m window --resize left:20:0 || \
            yabai -m window --resize right:20:0
        resize < j : yabai -m window --resize top:0:20 || \
            yabai -m window --resize bottom:0:20
        resize < k : yabai -m window --resize top:0:-20 || \
            yabai -m window --resize bottom:0:-20
      '';
    };

    # launchd.user.agents.skhd.environment = {
    #   NIX_SSL_CERT_FILE = "/etc/ssl/certs/ca-certificates.crt";
    #   SHELL = "/bin/sh";
    # };

    launchd.user.agents.skhd.serviceConfig.EnvironmentVariables.PATH =
      lib.mkForce
        "${config.services.yabai.package}/bin:${config.services.skhd.package}/bin:${config.my-meta.systemPath}";

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

    system.activationScripts.postActivation.text =
      let path = "${pkgs.skhd}/bin/skhd";
      in ''
        ${pkgs.sqlite}/bin/sqlite3 '/Library/Application Support/com.apple.TCC/TCC.db' \
          'INSERT or REPLACE INTO access VALUES("kTCCServiceAccessibility","${path}",1,2,4,1,NULL,NULL,0,NULL,NULL,0,NULL);
          DELETE from access where client_type = 1 and client != "${path}" and client like "%/bin/skhd";'
      '';
  }
