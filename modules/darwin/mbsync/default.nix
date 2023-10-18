{ config
, lib
, pkgs
, ...
}:

# credits to home-manager and @cmacrae
# https://github.com/nix-community/home-manager/blob/master/modules/services/mbsync.nix
# https://github.com/LnL7/nix-darwin/pull/275

with lib;

let

  cfg = config.services.mbsync-darwin;

  mbsyncOptions = [ "--all" ] ++ optional (cfg.verbose) "--verbose"
    ++ optional (cfg.configFile != "")
    "--config ${cfg.configFile}";

  cmd = pkgs.writeShellScriptBin "mbsync-agents" ''
    ${optionalString (cfg.preExec != "") cfg.preExec}
    ${cfg.package}/bin/mbsync ${concatStringsSep " " mbsyncOptions}
    ${optionalString (cfg.postExec != "") cfg.postExec}
  '';
in
{

  options.services.mbsync-darwin = {
    enable = mkEnableOption "mbsync-darwn";

    package = mkOption {
      type = types.package;
      default = pkgs.isync;
      defaultText = literalExample "pkgs.isync";
      example = literalExample "pkgs.isync";
      description = "The package to use for the mbsync binary.";
    };

    startInterval = mkOption {
      type = types.nullOr types.int;
      default = 300;
      example = literalExample "300";
      description = "Optional key to run mbsync every N seconds";
    };

    verbose = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether mbsync should produce verbose output.
      '';
    };

    configFile = mkOption {
      type = types.str;
      default = "";
      description = ''
        Optional configuration file to link to use instead of
        the default file (<filename>~/.mbsyncrc</filename>).
      '';
    };

    preExec = mkOption {
      type = types.str;
      default = "";
      example = "mkdir -p %h/mail";
      description = ''
        An optional command to run before mbsync executes.  This is
        useful for creating the directories mbsync is going to use.
      '';
    };

    postExec = mkOption {
      type = types.str;
      default = "";
      example = "\${pkgs.mu}/bin/mu index";
      description = ''
        An optional command to run after mbsync executes successfully.
        This is useful for running mailbox indexing tools.
      '';
    };
  };

  config = mkIf cfg.enable {

    launchd.agents.mbsync-darwin = {
      enable = true;
      config = {
        # Label = "mbsync-darwin";
        ProgramArguments = [ "${pkgs.bash}/bin/bash" "-c" "${cmd}/bin/mbsync-agents" ];
        KeepAlive = false;
        RunAtLoad = true;
        StartInterval = cfg.startInterval;
        StandardErrorPath = "/tmp/mbsync.err.log";
        StandardOutPath = "/tmp/mbsync.out.log";
      };
    };
  };
}
