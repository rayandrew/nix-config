{ config, lib, pkgs, ... }:

with lib;

{
  options.my = {
    systemPath = mkOption { type = types.str; };
  };
  config = {
    my = {
      systemPath = builtins.replaceStrings
        [ "$HOME" "$USER" ] [ "/Users/${config.my.username}" config.my.username ]
        config.environment.systemPath;
    };
  };
}
