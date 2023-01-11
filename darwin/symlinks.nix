{ config, lib, pkgs, ... }:

if builtins.hasAttr "hm" lib then
let home = config.home.homeDirectory;
in
{
  disabledModules = [ "targets/darwin/linkapps.nix" ];
  home.activation = lib.mkIf pkgs.stdenv.isDarwin {
      copyApplications = let
        apps = pkgs.buildEnv {
          name = "home-manager-applications";
          paths = config.home.packages;
          pathsToLink = "/Applications";
        };
      in lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        baseDir="$HOME/Applications/Home Manager Apps"
        if [ -d "$baseDir" ]; then
          rm -rf "$baseDir"
        fi
        mkdir -p "$baseDir"
        # for appFile in "${apps}/Applications/Home Manager Apps/*"; do
        for appFile in ${apps}/Applications/*; do
          target="$baseDir/$(basename "$appFile")"
          $DRY_RUN_CMD cp ''${VERBOSE_ARG:+-v} -fHRL "$appFile" "$baseDir"
          $DRY_RUN_CMD chmod ''${VERBOSE_ARG:+-v} -R +w "$target"
        done
      '';
      rerunWM = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        # long time to mount /nix somehow makes this service failed

        # unload
        # /bin/launchctl unload ${home}/Library/LaunchAgents/org.nixos.yabai.plist
        # /bin/launchctl unload ${home}/Library/LaunchAgents/org.nixos.skhd.plist
        # /bin/launchctl unload ${home}/Library/LaunchAgents/org.nixos.sketchybar.plist

        # reload
        # /bin/launchctl load ${home}/Library/LaunchAgents/org.nixos.yabai.plist
        # /bin/launchctl load ${home}/Library/LaunchAgents/org.nixos.skhd.plist
        # /bin/launchctl load ${home}/Library/LaunchAgents/org.nixos.sketchybar.plist
      '';
  };
}
else 
{
  system.activationScripts.applications.text = pkgs.lib.mkForce (
    ''
      echo "setting up ~/Applications..." >&2
      rm -rf ~/Applications/Nix\ Apps
      mkdir -p ~/Applications/Nix\ Apps
      IFS=$'\n'  
      for app in $(find ${config.system.build.applications}/Applications -maxdepth 1 -type l); do
        src="$(/usr/bin/stat -f%Y "$app")"
        cp -r "$src" ~/Applications/Nix\ Apps
      done
    ''
  );
}
