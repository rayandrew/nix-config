{ pkgs
, lib
, ...
}:

let
  alt = "Mod1";
  modifier = "Mod4";
  term = "kitty";
  # term = "st -e ${pkgs.fish}/bin/fish";
in
{
  xsession = {
    enable = true;
    windowManager.i3 = {
      inherit modifier;
      enable = true;
      package = pkgs.i3-gaps;
      keybindings = lib.mkOptionDefault {
        "${modifier}+Shift+q" = "kill";
        # "${modifier}+d" = "exec ${pkgs.dmenu}/bin/dmenu_run";
        "${modifier}+d" = "exec --no-startup-id \"${pkgs.rofi}/bin/rofi -show drun -modi run,drun,window\"";

        "${alt}+F4" = "kill";

        # "${modifier}+Return" = "exec kitty";
        "${modifier}+Return" = "exec ${term}";
        "${modifier}+Shift+Return" = "exec ${term} -c \"tmux attach || tmux new-session\"";

        "${modifier}+h" = "focus left";
        "${modifier}+j" = "focus down";
        "${modifier}+k" = "focus up";
        "${modifier}+l" = "focus right";

        "${modifier}+Shift+h" = "move left";
        "${modifier}+Shift+j" = "move down";
        "${modifier}+Shift+k" = "move up";
        "${modifier}+Shift+l" = "move right";

        "${modifier}+Shift+v" = "split h";
        "${modifier}+v" = "split v";
      };
    };
  };

  home.packages = with pkgs; [
    dmenu #application launcher most people use
    i3status-rust
    i3-gaps
    i3lock-fancy
    rofi
  ];

  programs.i3status-rust = {
    enable = true;

    bars."${barName}" = {
      theme = "plain";
      icons = "awesome";
      blocks = [
        {
          block = "net";
          device = "wlp0s20f3";
          format = "{ssid} {signal_strength} {ip} {speed_down;K*b} {graph_down;K*b}";
          interval = 5;
        }
        {
          block = "disk_space";
          path = "/";
          alias = "/";
          info_type = "available";
          unit = "GB";
          interval = 60;
          warning = 20.0;
          alert = 10.0;
        }
        {
          block = "memory";
          display_type = "memory";
          format_mem = "{mem_used_percents}";
          format_swap = "{swap_used_percents}";
        }
        {
          block = "cpu";
          interval = 1;
        }
        {
          block = "load";
          interval = 1;
          format = "{1m}";
        }
        {
          block = "battery";
          interval = 10;
          format = "{percentage:6#100} {percentage} {time}";
        }
        {
          block = "sound";
        }
        {
          block = "time";
          interval = 60;
          format = "%a %d/%m %R";
        }
      ];
    };
  };
}
