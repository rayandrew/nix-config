# https://github.com/thiagokokada/nix-configs/blob/70b9835b464109da9132507c0ea5c382d6251658/home-manager/i3/common.nix#L266

{ config
, lib
, areaScreenShot
, browser
, dunstctl
, fileManager
, fullScreenShot
, light
, menu
, pamixer
, playerctl
, terminal
, statusCommand ? null
, alt ? "Mod1"
, modifier ? "Mod4"
, extraBindings ? { }
, extraWindowOptions ? { }
, extraFocusOptions ? { }
, extraModes ? { }
, extraConfig ? ""
, workspaces ? [
    {
      ws = 1;
      name = "1";
    }
    {
      ws = 2;
      name = "2";
    }
    {
      ws = 3;
      name = "3";
    }
    {
      ws = 4;
      name = "4";
    }
    {
      ws = 5;
      name = "5";
    }
    {
      ws = 6;
      name = "6";
    }
    {
      ws = 7;
      name = "7";
    }
    {
      ws = 8;
      name = "8";
    }
    {
      ws = 9;
      name = "9";
    }
    {
      ws = 0;
      name = "10";
    }
  ]
}:
let
  # Modes
  powerManagementMode =
    " : Screen [l]ock, [e]xit, [s]uspend, [h]ibernate, [R]eboot, [S]hutdown";
  resizeMode = " : [h]  , [j]  , [k]  , [l] ";

  # Helpers
  mapDirection = { prefixKey ? null, leftCmd, downCmd, upCmd, rightCmd }:
    with lib.strings; {
      # Arrow keys
      "${optionalString (prefixKey != null) "${prefixKey}+"}Left" = leftCmd;
      "${optionalString (prefixKey != null) "${prefixKey}+"}Down" = downCmd;
      "${optionalString (prefixKey != null) "${prefixKey}+"}Up" = upCmd;
      "${optionalString (prefixKey != null) "${prefixKey}+"}Right" = rightCmd;
      # Vi-like keys
      "${optionalString (prefixKey != null) "${prefixKey}+"}h" = leftCmd;
      "${optionalString (prefixKey != null) "${prefixKey}+"}j" = downCmd;
      "${optionalString (prefixKey != null) "${prefixKey}+"}k" = upCmd;
      "${optionalString (prefixKey != null) "${prefixKey}+"}l" = rightCmd;
    };

  mapDirectionDefault = { prefixKey ? null, prefixCmd }:
    (mapDirection {
      inherit prefixKey;
      leftCmd = "${prefixCmd} left";
      downCmd = "${prefixCmd} down";
      upCmd = "${prefixCmd} up";
      rightCmd = "${prefixCmd} right";
    });

  mapWorkspacesStr = with builtins;
    with lib.strings;
    { workspaces, prefixKey ? null, prefixCmd }:
    (concatStringsSep "\n" (map
      ({ ws, name }:
        ''
          bindsym ${optionalString (prefixKey != null) "${prefixKey}+"}${
            toString ws
          } ${prefixCmd} "${name}"'')
      workspaces));
in
{
  helpers = { inherit mapDirection mapDirectionDefault mapWorkspacesStr; };

  config = {
    inherit modifier terminal;

    keybindings = lib.mkOptionDefault {
      # "${modifier}+d" = "exec ${pkgs.dmenu}/bin/dmenu_run";
      "${modifier}+d" = "exec ${menu}";

      "${modifier}+Return" = "exec ${terminal}";
      "${modifier}+Shift+Return" = "exec ${terminal} \"tmux attach || tmux new-session\"";

      "${modifier}+r" = ''mode "${resizeMode}"'';
      "${modifier}+Escape" = ''mode "${powerManagementMode}"'';

      "${modifier}+Shift+c" = "reload";
      "${modifier}+Shift+r" = "restart";
      "${modifier}+Shift+q" = "kill";
      "${modifier}+Shift+e" = "exit";
      "${alt}+F4" = "kill";

      "${modifier}+h" = "focus left";
      "${modifier}+j" = "focus down";
      "${modifier}+k" = "focus up";
      "${modifier}+l" = "focus right";

      "${modifier}+f" = "fullscreen toggle";
      "${modifier}+v" = "split v";
      "${modifier}+b" = "split h";

      "${modifier}+Shift+h" = "move left";
      "${modifier}+Shift+j" = "move down";
      "${modifier}+Shift+k" = "move up";
      "${modifier}+Shift+l" = "move right";

      "${modifier}+Shift+v" = "split h";
      "${modifier}+v" = "split v";

      "XF86AudioRaiseVolume" =
        "exec --no-startup-id ${pamixer} --set-limit 150 --allow-boost -i 5";
      "XF86AudioLowerVolume" =
        "exec --no-startup-id ${pamixer} --set-limit 150 --allow-boost -d 5";
      "XF86AudioMute" =
        "exec --no-startup-id ${pamixer} --toggle-mute";
      "XF86AudioMicMute" =
        "exec --no-startup-id ${pamixer} --toggle-mute --default-source";

      "XF86MonBrightnessUp" = "exec --no-startup-id ${light} -A 5%";
      "XF86MonBrightnessDown" = "exec --no-startup-id ${light} -U 5%";
    };

    modes =
      let
        exitMode = {
          "Escape" = "mode default";
          "Return" = "mode default";
        };
      in
      {
        ${resizeMode} = (mapDirection {
          leftCmd = "resize shrink width 10px or 10ppt";
          downCmd = "resize grow height 10px or 10ppt";
          upCmd = "resize shrink height 10px or 10ppt";
          rightCmd = "resize grow width 10px or 10ppt";
        }) // exitMode;
        ${powerManagementMode} = {
          l = "mode default, exec loginctl lock-session";
          e = "mode default, exec loginctl terminate-session $XDG_SESSION_ID";
          s = "mode default, exec systemctl suspend";
          h = "mode default, exec systemctl hibernate";
          "Shift+r" = "mode default, exec systemctl reboot";
          "Shift+s" = "mode default, exec systemctl poweroff";
        } // exitMode;
      } // extraModes;

    workspaceAutoBackAndForth = true;
    workspaceLayout = "tabbed";

    window = {
      border = 1;
      hideEdgeBorders = "smart";
      titlebar = false;
    } // extraWindowOptions;

    focus = { followMouse = false; } // extraFocusOptions;
  };

  # Until this issue is fixed we need to map workspaces directly to config file
  # https://github.com/nix-community/home-manager/issues/695
  extraConfig =
    let
      workspaceStr = (builtins.concatStringsSep "\n" [
        (mapWorkspacesStr {
          inherit workspaces;
          prefixKey = modifier;
          prefixCmd = "workspace number";
        })
        (mapWorkspacesStr {
          inherit workspaces;
          prefixKey = "${modifier}+Shift";
          prefixCmd = "move container to workspace number";
        })
      ]);
    in
    ''
      ${workspaceStr}
      ${extraConfig}
    '';
}
