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
  options = {
    yabai_spaces_file = lib.mkOption {
      type = lib.types.str;
      default = "/Users/rayandrew/.yabai-spaces";
    };
  };

  config = {
    yabai_spaces_file = "/Users/rayandrew/.yabai-spaces";

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
        # window_shadow = "float";
        window_shadow = "off";
        window_border = "on";
        window_border_width = 2;
        window_border_radius = 10;
        # window_border_hidpi = "on";
        window_border_blur = "off";
        # active_window_border_color = "0xff575F66";
        # normal_window_border_color = "0xfffafafa";
        normal_window_border_color = "#282828";
        active_window_border_color = "#ebdbb2";
        # insert_window_border_color   = "0xffd75f5f";
        # Bar
        external_bar = "all:32:0";
      };

      extraConfig = ''
        wait4path /etc/sudoers.d/yabai
        sudo yabai --load-sa

        yabai -m signal --add event=dock_did_restart action="sudo yabai --load-sa"

        # sketchybar utils
        yabai -m signal --add event=window_focused action="sketchybar --trigger window_focus"
        yabai -m signal --add event=window_created action="sketchybar --trigger windows_created"
        yabai -m signal --add event=window_destroyed action="sketchybar --trigger windows_destroyed"

        # focus window after active space changes
        yabai -m signal --add event=space_change action="yabai -m window --focus \$(yabai -m query --windows --space | jq .[0].id)"
        # focus window after active display changes
        yabai -m signal --add event=display_changed action="yabai -m window --focus \$(yabai -m query --windows --space | jq .[0].id)"

        bash ${scripts}/organize.sh
      '';
    };

    launchd.user.agents.yabai.serviceConfig.EnvironmentVariables.PATH =
      lib.mkForce
        "${config.services.yabai.package}/bin:${pkgs.jq}/bin:${config.services.sketchybar.package}/bin:${config.my-meta.systemPath}:${pkgs.python39}/bin";

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

  };
}
