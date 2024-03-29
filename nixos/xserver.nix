{ config, pkgs, lib, ... }:

let
  inherit (config.my-meta) username;
in
{
  boot = {
    consoleLogLevel = 3;
    kernelParams = [
      # Force kernel log in tty1, otherwise it will override greetd
      "console=tty1"
    ];
    plymouth.enable = lib.mkDefault true;
  };

  # Configure the virtual console keymap from the xserver keyboard settings
  console.useXkbConfig = true;

  # For gtkgreet
  environment.systemPackages = with pkgs; [ nordic ];

  # Configure special programs (i.e. hardware access)
  programs = {
    dconf.enable = true;
    light.enable = true;
  };

  services = {
    autorandr.enable = true;
    keyd = {
      enable = true;
      keyboards.default = {
        settings = {
          main = {
            capslock = "overload(control, esc)";
          };
        };

        # shift = {
        #   leftshift = "capslock";
        #   rightshift = "capslock";
        # };
      };
    };
    # Configure greetd, a lightweight session manager
    # greetd = {
    #   enable = true;
    #   settings = rec {
    #     initial_session = {
    #       command = "${pkgs.sway}/bin/sway --config ${pkgs.writeText "sway-config" ''
    #         # `-l` activates layer-shell mode. Notice that `swaymsg exit` will run after gtkgreet.
    #         exec "GTK_THEME=Nordic-bluish-accent ${pkgs.greetd.gtkgreet}/bin/gtkgreet -l; swaymsg exit"
    #         # exec "${pkgs.greetd.gtkgreet}/bin/gtkgreet -l; swaymsg exit"
    #
    #         bindsym Mod4+Escape exec ${pkgs.sway}/bin/swaynag \
    #           -t warning \
    #           -m 'What do you want to do?' \
    #           -b 'Poweroff' 'systemctl poweroff' \
    #           -b 'Reboot' 'systemctl reboot'
    #
    #         include /etc/sway/config.d/*
    #       ''}";
    #       user = "greeter";
    #     };
    #     default_session = initial_session;
    #   };
    #   vt = 7;
    # };

    xserver = {
      enable = true;

      # Enable sx, a lightweight startx alternative
      # displayManager.sx.enable = true;

      # enable if using i3
      displayManager = {
        lightdm.enable = true;
        autoLogin = { enable = false; user = username; };
        defaultSession = "xsession";
        session = [
          {
            manage = "desktop";
            name = "xsession";
            start = ''exec $HOME/.xsession'';
          }
        ];
      };

      # videoDrivers = [ "modesetting" ];

      # Enable libinput
      libinput = {
        enable = true;
        touchpad = {
          naturalScrolling = true;
          tapping = true;
        };
        mouse = {
          accelProfile = "flat";
        };
      };
    };
  };

  # environment.etc."greetd/environments".text = ''
  #   sway
  #   sx
  # '';

  # https://github.com/apognu/tuigreet/issues/76
  # systemd.tmpfiles.rules = [
  #   "d /var/cache/tuigreet 700 ${config.services.greetd.settings.initial_session.user} nobody"
  # ];
}
