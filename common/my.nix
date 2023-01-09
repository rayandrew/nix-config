{ config, lib, pkgs, ... }:

let
  inherit (lib) mkOption types;
   dirModule = types.submodule {
    options = {
      nix = mkOption {
        type = types.str;
        # default = "${config.home.homeDirectory}/.config/nixpkgs";
        description = "Path to `nixpkgs` directory";
      };

      projects = mkOption {
        type = types.str;
        # default = "${config.home.homeDirectory}/Projects";
        # defaultText = "\${config.home.homeDirectory}/Projects";
        description = "Path to `Projects` directory";
      };
    };
  };
in
{
  options.my = {
    username = mkOption { type = types.str; };
    name = mkOption { type = types.str; };
    email = mkOption { type = types.str; };
    uid = mkOption { type = types.int; };
    keys = mkOption { type = types.listOf types.singleLineStr; };
    directory = mkOption { type = with types; nullOr dirModule; default = null; };
  };
  config = {
    my = {
      username = "rayandrew";
      name = "Ray Andrew";
        email = "4437323+rayandrew@users.noreply.github.com";
      uid = 1000;
      keys = [ ];
      directory = {
        nix = "${config.home.homeDirectory}/.config/nixpkgs";
        projects = "${config.home.homeDirectory}/Projects";
      };
    };
  };
}
