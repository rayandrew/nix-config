{ config
, lib
, pkgs
, ...
}:

with lib;

let
  cfg = config.services.davmail;

  configType = with types;
    oneOf [ (attrsOf configType) str int bool ] // {
      description = "davmail config type (str, int, bool or attribute set thereof)";
    };

  toStr = val: if isBool val then boolToString val else toString val;

  linesForAttrs = attrs: concatMap
    (name:
      let value = attrs.${name}; in
      if isAttrs value
      then map (line: name + "." + line) (linesForAttrs value)
      else [ "${name}=${toStr value}" ]
    )
    (attrNames attrs);

  configFile = pkgs.writeText "davmail.properties" (concatStringsSep "\n" (linesForAttrs cfg.config));

in
{
  options.services.davmail = with types; {
    enable = mkEnableOption (lib.mdDoc "davmail, an MS Exchange gateway");

    package = mkOption {
      type = path;
      description = "The davmail package to use.";
      default = pkgs.davmail;
    };

    url = mkOption {
      type = types.str;
      description = lib.mdDoc "Outlook Web Access URL to access the exchange server, i.e. the base webmail URL.";
      example = "https://outlook.office365.com/EWS/Exchange.asmx";
      default = "https://outlook.office365.com/EWS/Exchange.asmx";
    };

    config = mkOption {
      type = configType;
      default = { };
      description = lib.mdDoc ''
        Davmail configuration. Refer to
        <http://davmail.sourceforge.net/serversetup.html>
        and <http://davmail.sourceforge.net/advanced.html>
        for details on supported values.
      '';
      example = literalExpression ''
        {
          davmail.allowRemote = true;
          davmail.imapPort = 55555;
          davmail.bindAddress = "10.0.1.2";
          davmail.smtpSaveInSent = true;
          davmail.folderSizeLimit = 10;
          davmail.caldavAutoSchedule = false;
          log4j.logger.rootLogger = "DEBUG";
        }
      '';
    };
  };

  config = mkIf cfg.enable (lib.mkMerge [
    {
      services.davmail.config = {
        davmail = mapAttrs (name: mkDefault) {
          server = true;
          disableUpdateCheck = true;
          logFilePath = "/tmp/davmail.log";
          logFileSize = "1MB";
          # mode = "auto";
          url = cfg.url;
          caldavPort = 1080;
          imapPort = 1143;
          ldapPort = 1389;
          popPort = 1110;
          smtpPort = 1025;
        };
        log4j = {
          logger.davmail = mkDefault "WARN";
          logger.httpclient.wire = mkDefault "WARN";
          logger.org.apache.commons.httpclient = mkDefault "WARN";
          rootLogger = mkDefault "WARN";
        };
      };
    }
    {
      home.packages = [ cfg.package ];

      launchd.agents.davmail = {
        enable = true;
        config = {
          ProgramArguments = [ "${cfg.package}/bin/davmail" "${configFile}" ];
          KeepAlive = true;
          RunAtLoad = true;
          # EnvironmentVariables = {
          #   PATH = "${cfg.package}/bin:${config.home.path}";
          # };
          StandardErrorPath = "/tmp/davmail.err.log";
          StandardOutPath = "/tmp/davmail.out.log";
        };
      };
    }
    (mkIf (cfg.config != "") {
      # home.activation.davmailConfig = ''
      #   rm -rf "${config.home.homeDirectory}/.config/davmail"
      #   if [[ ! -h "${cfg.config}" ]]; then
      #     ln -s "${cfg.config}" "${config.home.homeDirectory}/.config/davmail"
      #   fi
      # '';
      # xdg.configFile."davmail/davmailrc" = {
      #   text = cfg.config;
      #   onChange = ''
      #     ${pkgs.procps}/bin/pkill -u "$USER" ''${VERBOSE+-e} davmail || true
      #   '';
      #   executable = true;
      # };
    })
  ]);
}
