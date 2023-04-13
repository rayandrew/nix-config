{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.sketchyvim;
in
{
  options = with types; {
    services.sketchyvim.enable = mkOption {
      type = bool;
      default = false;
      description = "Whether to enable the sketchyvim";
    };

    services.sketchyvim.package = mkOption {
      type = path;
      description = "The sketchyvim package to use.";
    };

    services.sketchyvim.config = mkOption {
      type = str;
      default = "";
      example = literalExpression ''
        noremap ß $
        nmap <C-k> <Esc>:m .+1<CR>==gn
        nmap <C-l> <Esc>:m .-2<CR>==gn
      '';
      description = ''
        Configuration.
      '';
    };
    services.sketchyvim.blacklist = mkOption {
      type = listOf str;
      default = [ ];
      example = [
        "Kitty"
      ];
      description = ''
        Blacklist.
      '';
    };
  };

  config = mkIf cfg.enable (lib.mkMerge [
    {
      home.packages = [ cfg.package ];

      launchd.agents.sketchyvim = {
        enable = true;
        config.ProgramArguments = [ "${cfg.package}/bin/svim" ];

        config.KeepAlive = true;
        config.RunAtLoad = true;
        config.EnvironmentVariables = {
          PATH = "${cfg.package}/bin:${config.home.path}";
        };
      };
    }

    (mkIf (cfg.config != "") {
      xdg.configFile."svim/svimrc" = {
        text = cfg.config;
        onChange = ''
          ${pkgs.procps}/bin/pkill -u "$USER" ''${VERBOSE+-e} svim || true
        '';
      };
    })

    (mkIf (builtins.length cfg.blacklist > 0) {
      xdg.configFile."svim/blacklist" = {
        text = lib.concatMapStrings (x: x + "\n") cfg.blacklist;
        onChange = ''
          ${pkgs.procps}/bin/pkill -u "$USER" ''${VERBOSE+-e} svim || true
        '';
      };
    })
  ]);
}
