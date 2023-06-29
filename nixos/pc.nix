{ config, pkgs, ... }:
let
  inherit (config.my-meta) username;
in
{


  services = {
    xserver = {
      enable = true;
      libinput.enable = true;
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
    };

    # Enable printing
    printing = {
      enable = true;
      drivers = with pkgs; [ ];
    };
  };
}
