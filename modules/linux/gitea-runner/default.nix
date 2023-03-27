{ pkgs
, lib
, config
, ...
}:

with lib;

let
  cfg = config.services.gitea-runner;
  opt = options.services.gitea-runner;
  exe = "${cfg.package}/bin/act_runner";
in
{
  imports = [ ];

  options = {
    services.gitea-runner = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc "Enable Gitea Runner Service.";
      };

      package = mkOption {
        default = pkgs.gitea-actions-runner;
        type = types.package;
        defaultText = literalExpression "pkgs.gitea";
        description = lib.mdDoc "gitea derivation to use";
      };

      instanceUrl = mkOption {
        type = types.str;
        description = lib.mdDoc "Full public URL of gitea server.";
      };

      token = mkOption {
        type = types.str;
        default = "";
        description = lib.mdDoc ''
          The token corresponding to register Gitea actions.
          Warning: this is stored in cleartext in the Nix store!
          Use {option}`tokenFile` instead.
        '';
      };

      tokenFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        example = "/run/keys/gitea-dbpassword";
        description = lib.mdDoc ''
          A file containing the token to register Gitea actions.
        '';
      };

      user = mkOption {
        type = types.str;
        default = "gitea-runner";
        description = lib.mdDoc "User account under which gitea-runner runs.";
      };

      stateDir = mkOption {
        default = "/var/lib/gitea-runner";
        type = types.str;
        description = lib.mdDoc "gitea runner data directory.";
      };
    };
  };

  config = mkIf cfg.enable {
    virtualisation.docker.enable = true;

    systemd.tmpfiles.rules = [
      "d '${cfg.stateDir}' 0750 ${cfg.user} gitea-runner - -"
      "Z '${cfg.stateDir}' - ${cfg.user} gitea-runner - -"
    ];

    users.users = mkIf (cfg.user == "gitea-runner") {
      gitea-runner = {
        description = "Gitea Runner Service";
        home = cfg.stateDir;
        useDefaultShell = true;
        group = "gitea-runner";
        extraGroups = [ "docker" ];
        isSystemUser = true;
      };
    };

    users.groups.gitea-runner = { };

    services.gitea-runner.tokenFile =
      mkDefault (toString (pkgs.writeTextFile {
        name = "gitea-runner-token";
        text = cfg.token;
      }));

    systemd.services.gitea-runner = {
      enable = true;
      description = "gitea-runner";
      after = [ "network.target" ];
      path = [ cfg.package ];
      preStart = ''
        TOKEN=$(head -n 1 ${cfg.tokenFile})
        ${exe} register --instance ${cfg.instanceUrl} --token $TOKEN --no-interactive
      '';

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = "gitea-runner";
        WorkingDirectory = cfg.stateDir;
        ExecStart = "${exe} daemon";
        Restart = "always";
        # Runtime directory and mode
        RuntimeDirectory = "gitea-runner";
        RuntimeDirectoryMode = "0755";
        # Access write directories
        ReadWritePaths = [ cfg.stateDir ];
        UMask = "0027";
        # Capabilities
        CapabilityBoundingSet = "";
        # Security
        NoNewPrivileges = true;
        # Sandboxing
        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
        PrivateDevices = true;
        PrivateUsers = true;
        ProtectHostname = true;
        ProtectClock = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = true;
        RestrictAddressFamilies = [ "AF_UNIX AF_INET AF_INET6" ];
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        PrivateMounts = true;
        # System Call Filtering
        SystemCallArchitectures = "native";
        SystemCallFilter = "~@clock @cpu-emulation @debug @keyring @module @mount @obsolete @raw-io @reboot @setuid @swap";
      };

      environment = {
        USER = cfg.user;
        HOME = cfg.stateDir;
      };
    };
  };
}
