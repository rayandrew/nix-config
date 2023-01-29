{ config, lib, pkgs, ... }:

{
  config = {
    # imports = [ ];
    hm.imports = [
      ({ config, lib, pkgs, ... }: {
        programs.kitty = { enable = lib.mkForce false; };
      })
    ];

    networking.computerName = "runner";
    networking.hostName = "runner";
    networking.knownNetworkServices = [ "Wi-Fi" "USB 10/100/1000 LAN" ];

    my = lib.mkForce {
      username = "runner";
      directory = {
        nix = "/Users/runner/work/nixpkgs/nixpkgs";
        projects = "/Users/runner/work/Projects";
        research = "/Users/runner/work/Research";
      };
    };

    homebrew.enable = lib.mkForce false;
  };
  # home-manager.users.runner.imports =
  #   [ ({ config, lib, pkgs, ... }: { programs.kitty = { enable = false; }; }) ];
}
