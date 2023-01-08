{ pkgs
, lib
, inputs
, config
, ...
}:

{
  services.yabai = {
    enable = true;
    enableScriptingAddition = true;
    # package = pkgs.yabai-git;
    package = pkgs.yabai;
    config = {
      # layout
      layout = "bsp";
      auto_balance = "off";
      split_ratio = "0.50";
      window_placement = "second_child";
      # Gaps
      window_gap = 18;
      top_padding = 18;
      bottom_padding = 52;
      left_padding = 18;
      right_padding = 18;
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
      active_window_border_color   = "0xff5c7e81";
      normal_window_border_color   = "0xff505050";
      insert_window_border_color   = "0xffd75f5f";
      # Bar
      external_bar = "all:32:0";
    };

    extraConfig = ''
      # focus window after active space changes
      yabai -m signal --add event=space_changed action="${pkgs.yabai}/bin/yabai  -m window --focus \$(yabai -m query --windows --space | ${pkgs.jq}/bin/jq .[0].id)"
      # focus window after active display changes
      yabai -m signal --add event=display_changed action="${pkgs.yabai}/bin/yabai -m window --focus \$(yabai -m query --windows --space | ${pkgs.jq}/bin/jq .[0].id)"

      yabai -m rule --add app="^Finder$" sticky=on layer=above manage=off
      ## Do not manage some apps which are not resizable
      yabai -m rule --add app="^(LuLu|Vimac|Calculator|VLC|System Settings|zoom.us|Photo Booth|Archive Utility|Python|LibreOffice)$" manage=off
      yabai -m rule --add label="raycast" app="^Raycast$" manage=off
      yabai -m rule --add label="1Password" app="^1Password$" layer=above manage=off
      yabai -m rule --add label="Safari" app="^Safari$" title="^(General|(Tab|Password|Website|Extension)s|AutoFill|Se(arch|curity)|Privacy|Advance)$" manage=off
      yabai -m rule --add label="System Settings" app="^System Preferences$" manage=off
      yabai -m rule --add label="App Store" app="^App Store$" manage=off
      yabai -m rule --add label="Activity Monitor" app="^Activity Monitor$" manage=off
      yabai -m rule --add label="Calculator" app="^Calculator$" manage=off
      yabai -m rule --add label="Dictionary" app="^Dictionary$" manage=off
      yabai -m rule --add label="Software Update" title="Software Update" manage=off
      yabai -m rule --add label="About This Mac" app="System Information" title="About This Mac" manage=off
      yabai -m rule --add app="^IntelliJ IDEA$" manage=off

      yabai -m rule --add app="^(Google Chrome|Firefox|Safari)$" space=10
      yabai -m rule --add app="^coreautha$" manage=off sticky=on layer=above # 1Password biometric
      # yabai -m rule --add app="^Alacritty$" spaces=2
      yabai -m rule --add app="^Skype$" spaces=3

      yabai -m space 1 --label one
      yabai -m space 2 --label two
      yabai -m space 3 --label three
      yabai -m space 4 --label four
      yabai -m space 5 --label five
      yabai -m space 6 --label six
      yabai -m space 7 --label seven
      yabai -m space 8 --label eight
      yabai -m space 9 --label nine
      yabai -m space 10 --label ten
    '';
  };

  services.skhd = {
    enable = true;
    package = pkgs.skhd;
  };

  system.defaults.NSGlobalDomain._HIHideMenuBar = true;
}
