{ config, lib, ... }:

let
  inherit (lib) mkOption types;
  
  dirModule = types.submodule {
    options = {
      nix = mkOption {
        type = types.str;
        default = "${config.home.homeDirectory}/.config/nixpkgs";
        description = "Path to `nixpkgs` directory";
      };

      projects = mkOption {
        type = types.str;
        default = "${config.home.homeDirectory}/Projects";
        defaultText = "\${config.home.homeDirectory}/Projects";
        description = "Path to `Projects` directory";
      };
    };
  };

in

{
  options.users.primaryUser = {
    username = mkOption {
      type = with types; nullOr string;
      default = null;
    };
    fullName = mkOption {
      type = with types; nullOr string;
      default = null;
    };
    email = mkOption {
      type = with types; nullOr string;
      default = null;
    };
    directory = mkOption {
      type = with types; nullOr dirModule;
      default = null;
    };
  };
}
