{ pkgs
, lib
, ...
}:

let
  cfg = config.services.gitea-runner;
  opt = options.services.gitea-runner;
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
    };
  };

  config = { };
}
