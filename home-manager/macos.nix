{ flake, config, lib, pkgs, ... }:

let home = config.home.homeDirectory;
in {
  imports = [
    ./default.nix
    ./graphical.nix
    ./fonts.nix
    ./sketchybar
    ./sketchyvim.nix
    ./mail
    ./mail/davmail.nix
    ./mail/mbsync-darwin.nix
  ];

  targets.darwin.defaults = {
    # Disable all automatic substitution
    NSGlobalDomain = {
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
    };
    # Do not write .DS_Store files outside macOS
    com.apple.desktopservices = {
      DSDontWriteNetworkStores = true;
      DSDontWriteUSBStores = true;
    };
    # Disable mouse acceleration
    com.apple.mouse.scalling = -1;
    # com.apple.trackpad.scalling = -1;
  };

  disabledModules = [ "targets/darwin/linkapps.nix" ];
  home.activation = lib.mkIf pkgs.stdenv.isDarwin {
    copyApplications =
      let
        apps = pkgs.buildEnv {
          name = "home-manager-applications";
          paths = config.home.packages;
          pathsToLink = "/Applications";
        };
      in
      lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        baseDir="$HOME/Applications/Home Manager Apps"
        if [ -d "$baseDir" ]; then
          rm -rf "$baseDir"
        fi
        mkdir -p "$baseDir"
        # for appFile in "${apps}/Applications/Home Manager Apps/*"; do
        for appFile in ${apps}/Applications/*; do
          baseAppFile=$(basename "$appFile")
          _baseDir="$baseDir"
          if [ "$baseAppFile" = "1Password.app" ]; then
            _baseDir="/Applications"
          fi
          target="$_baseDir/$baseAppFile"
          $DRY_RUN_CMD cp ''${VERBOSE_ARG:+-v} -fHRL "$appFile" "$_baseDir"
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
    # yabai = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    #   if [ -f ${home}/Library/LaunchAgents/org.nixos.yabai.plist ]; then
    #     /bin/launchctl unload ${home}/Library/LaunchAgents/org.nixos.yabai.plist
    #     /bin/launchctl load ${home}/Library/LaunchAgents/org.nixos.yabai.plist
    #   fi
    # '';
    skhd = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if [ -f ${home}/Library/LaunchAgents/org.nixos.skhd.plist ]; then
        /bin/launchctl unload ${home}/Library/LaunchAgents/org.nixos.skhd.plist
        /bin/launchctl load ${home}/Library/LaunchAgents/org.nixos.skhd.plist
      fi
    '';
    # sketchybar = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    #   if [ -f ${home}/Library/LaunchAgents/org.nixos.sketchybar.plist ]; then
    #     /bin/launchctl unload ${home}/Library/LaunchAgents/org.nixos.sketchybar.plist
    #     /bin/launchctl load ${home}/Library/LaunchAgents/org.nixos.sketchybar.plist
    #   fi
    # '';

  };

  home.packages = with pkgs; [
    nix-cleanup
    iterm2
  ];
}
