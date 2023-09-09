{ config
, lib
, pkgs
, ...
}:

with lib;

let
  cfg = config.services.sketchybar;
in
{
  options = with types; {
    services.sketchybar.enable = mkOption {
      type = bool;
      default = false;
      description = "Whether to enable the sketchybar";
    };

    services.sketchybar.package = mkOption {
      type = path;
      description = "The sketchybar package to use.";
    };

    services.sketchybar.config = mkOption {
      type = nullOr path;
      default = null;
      # example = literalExpression ''
      #   sketchybar -m --bar height=25
      #   echo "sketchybar configuration loaded.."
      # '';
      # description = ''
      #   Configuration.
      # '';
    };
  };

  config = mkIf cfg.enable (lib.mkMerge [
    {
      home.packages = [ cfg.package ];

      launchd.agents.sketchybar = {
        enable = true;
        config.ProgramArguments = [ "${cfg.package}/bin/sketchybar" ];

        config.KeepAlive = true;
        config.RunAtLoad = true;
        config.EnvironmentVariables = {
          PATH = "${cfg.package}/bin:${config.home.path}";
        };
      };
    }
    (mkIf (cfg.config != "") {
      home.activation.sketchybarConfig = ''
        rm -rf "${config.home.homeDirectory}/.config/sketchybar"
        if [[ ! -h "${cfg.config}" ]]; then
          ln -s "${cfg.config}" "${config.home.homeDirectory}/.config/sketchybar"
        fi
      '';
      # xdg.configFile."sketchybar/sketchybarrc" = {
      #   text = cfg.config;
      #   onChange = ''
      #     ${pkgs.procps}/bin/pkill -u "$USER" ''${VERBOSE+-e} sketchybar || true
      #   '';
      #   executable = true;
      # };
    })
  ]);
}
  
