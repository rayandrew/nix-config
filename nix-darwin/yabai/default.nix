{ config, lib, pkgs, ... }:

let
  scripts = ./scripts;
  recordWindowId = pkgs.writeShellScriptBin "yabai-record-window-id" ''
    window_id=$(yabai -m query --windows | jq -er 'map(select(."has-focus" == true))[0].id')
    ${pkgs.ruby}/bin/ruby ${scripts}/focus.rb write "$window_id"
  '';
  focusPrevWindow = pkgs.writeShellScriptBin "yabai-focus-prev-window" ''
    previous_window_id=$(${pkgs.ruby}/bin/ruby ${scripts}/focus.rb read $YABAI_WINDOW_ID)
    yabai -m window --focus $previous_window_id
  '';
in
{
  # csrutil enable --without fs --without debug --without nvram
  # nvram boot-args=-arm64e_preview_abi
  environment.etc."sudoers.d/yabai".text = ''
    ${config.my-meta.username} ALL = (root) NOPASSWD: ${config.services.yabai.package}/bin/yabai --load-sa
  '';

  services.yabai = {
    enable = true;
    enableScriptingAddition = true;
    # package = pkgs.unstable.yabai;
    config = {
      # layout
      layout = "bsp";
      auto_balance = "off";
      split_ratio = "0.50";
      window_placement = "second_child";
      # Gaps
      window_gap = 12;
      top_padding = 12;
      # bottom_padding = 44;
      bottom_padding = 4;
      left_padding = 6;
      right_padding = 6;
      # mouse
      mouse_follows_focus = "off";
      focus_follows_mouse = "off";
      mouse_modifier = "fn";
      mouse_action1 = "move";
      mouse_action2 = "resize";
      mouse_drop_action = "swap";
      # shadows and borders
      window_shadow = "float";
      window_border = "off";
      window_border_width = 3;
      window_border_radius = 3;
      active_window_border_color = "0xff5c7e81";
      normal_window_border_color = "0xff505050";
      # insert_window_border_color   = "0xffd75f5f";
      # Bar
      external_bar = "all:32:0";
    };

    extraConfig = ''
      wait4path /etc/sudoers.d/yabai
      sudo yabai --load-sa

      yabai -m signal --add event=dock_did_restart action="sudo yabai --load-sa"

      # creating workspaces 
      # yabai -m signal --add event=display_added action="sleep 1 && bash ${scripts}/create-spaces.sh"
      # yabai -m signal --add event=display_removed action="sleep 1 && bash ${scripts}/create-spaces.sh"

      # sketchybar utils
      yabai -m signal --add event=window_focused action="sketchybar --trigger window_focus"
      yabai -m signal --add event=window_created action="sketchybar --trigger windows_on_spaces"
      yabai -m signal --add event=window_destroyed action="sketchybar --trigger windows_on_spaces"

      # destroy utils
      # yabai -m signal --add event=window_focused action="${recordWindowId}/bin/yabai-record-window-id"
      # yabai -m signal --add event=application_front_switched action="${recordWindowId}/bin/yabai-record-window-id"
      # yabai -m signal --add event=window_destroyed action="${focusPrevWindow}/bin/yabai-focus-prev-window"

      # focus window after active space changes
      yabai -m signal --add event=space_changed action="yabai -m window --focus \$(yabai -m query --windows --space | jq .[0].id)"
      # focus window after active display changes
      yabai -m signal --add event=display_changed action="yabai -m window --focus \$(yabai -m query --windows --space | jq .[0].id)"

      ## Do not manage some apps which are not resizable
      yabai -m rule --add app="^(LuLu|Vimac|Calculator|VLC|System Settings|zoom.us|Photo Booth|Archive Utility|Python|LibreOffice)$" manage=off
      yabai -m rule --add label="raycast" app="^Raycast$" manage=off
      yabai -m rule --add label="1Password" app="^1Password$" layer=above manage=off
      yabai -m rule --add label="Safari" app="^Safari$" title="^(General|(Tab|Password|Website|Extension)s|AutoFill|Se(arch|curity)|Privacy Report|Advance)$" manage=off
      yabai -m rule --add label="System Settings" app="^System Preferences$" manage=off
      yabai -m rule --add label="App Store" app="^App Store$" manage=off
      yabai -m rule --add label="Activity Monitor" app="^Activity Monitor$" manage=off
      yabai -m rule --add label="Calculator" app="^Calculator$" manage=off
      yabai -m rule --add label="Dictionary" app="^Dictionary$" manage=off
      yabai -m rule --add label="Software Update" title="Software Update" manage=off
      yabai -m rule --add label="About This Mac" app="System Information" title="About This Mac" manage=off
      yabai -m rule --add app="^IntelliJ IDEA$" manage=off
      yabai -m rule --add app="^coreautha$" manage=off # 1Password biometric
      yabai -m rule --add app="^Installer$" manage=off 
      yabai -m rule --add app="^Cisco AnyConnect Secure Mobility Client$" layer=above manage=off 
      yabai -m rule --add label="Orion" app="^Orion$" title="^(General|Appearance|Browsing|Sync|Passwords|Privacy|Search|Websites)$" manage=off
      yabai -m rule --add label="Arc" app="^Arc$" title="^(Account|General|Shortcuts|Little Arc|Previews|Updates|Archive|Site Settings|Advanced)$" manage=off
      yabai -m rule --add label="Desmume" app="^DeSmuME$" manage=off

      yabai -m rule --add app="^Finder$" sticky=on manage=off # layer=above 
      # yabai -m rule --add app="^(Neovide|Notion)$" manage=on space=3 # for note-taking
      # yabai -m rule --add app="^Linear$" space=3
      yabai -m rule --add app="^(Mail|Calendar|Fantastical|Spark Desktop)$" space=4
      yabai -m rule --add label="Communication" app="^(Skype|Slack|Discord)$" space=4
      yabai -m rule --add app="^(Google Chrome|Firefox|Safari|Orion|Arc)$" space=1
      # yabai -m rule --add label="Little Arc" app="^Arc$" title="^Space.*" manage=off # for Little Arc to be happy

      for _ in $(yabai -m query --spaces | jq '.[].index | select(. > 6)'); do
        yabai -m space --destroy 7
      done
      
      function setup_space {
        local idx="$1"
        local name="$2"
        shift
        shift
        local space=
        echo "setup space $idx : $name"
      
        space=$(yabai -m query --spaces --space "$idx")
        if [ -z "$space" ]; then
          yabai -m space --create
        fi
      
        yabai -m space "$idx" --label "$name" $@
      }
      
      setup_space 1 web --layout stack
      setup_space 2 main 
      setup_space 3 code
      setup_space 4 social --layout stack
      setup_space 5 commands 
      setup_space 6 other

      # bash ${scripts}/create-spaces.sh
    '';
  };

  launchd.user.agents.yabai.serviceConfig.EnvironmentVariables.PATH =
    lib.mkForce
      "${config.services.yabai.package}/bin:${pkgs.jq}/bin:${config.services.sketchybar.package}/bin:${config.my-meta.systemPath}";

  launchd.user.agents.yabai.serviceConfig = {
    StandardErrorPath = "/tmp/yabai.err.log";
    StandardOutPath = "/tmp/yabai.out.log";
  };

  launchd.daemons.yabai-sa.script = lib.mkOrder 0 ''
    wait4path ${config.services.yabai.package}/bin/yabai
  '';

  system.activationScripts.postActivation.text =
    let path = "${pkgs.yabai}/bin/yabai";
    in ''
        ${pkgs.sqlite}/bin/sqlite3 '/Library/Application Support/com.apple.TCC/TCC.db' \
        'INSERT or REPLACE INTO access VALUES("kTCCServiceAccessibility","${path}",1,2,4,1,NULL,NULL,0,NULL,NULL,0,NULL);
      DELETE from access where client_type = 1 and client != "${path}" and client like "%/bin/yabai";'
    '';

  environment.systemPackages = [
    (pkgs.writeShellScriptBin "yabai-create-space" ''
      bash ${scripts}/create-spaces.sh
    '')
  ];

}
