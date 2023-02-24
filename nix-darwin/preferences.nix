{ config, lib, pkgs, ... }:

{
  networking.dns = [ "1.1.1.1" "8.8.8.8" ];
  environment.systemPackages = with pkgs; [ sf-symbols-app ];
  environment.variables = {
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
  };
  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      jetbrains-mono-nerdfont
      sf-symbols
      recursive
      (nerdfonts.override { fonts = [ "FiraCode" "Ubuntu" ]; })
    ];
  };
  nix.extraOptions = ''
    extra-platforms = x86_64-darwin
  '';
  launchd.daemons.activate-system.script = lib.mkOrder 0 ''
    wait4path /nix/store
    # wait4path /run/current-system
  '';
  services.nix-daemon.enable = true;
  services.activate-system.enable = true;
  # nix profile diff-closures --profile /nix/var/nix/profiles/system
  system.activationScripts.postActivation.text = ''
    # disable spotlight
    launchctl unload -w /System/Library/LaunchDaemons/com.apple.metadata.mds.plist >/dev/null 2>&1 || true
    # show upgrade diff
    ${pkgs.nix}/bin/nix store --experimental-features nix-command diff-closures /run/current-system "$systemConfig"
  '';
  system.defaults = {
    NSGlobalDomain = {
      AppleMeasurementUnits = "Centimeters";
      AppleMetricUnits = 1;
      AppleShowAllExtensions = true;
      AppleTemperatureUnit = "Celsius";
      AppleInterfaceStyle = "Light";
      AppleInterfaceStyleSwitchesAutomatically = false;
      InitialKeyRepeat = 20;
      KeyRepeat = 2;
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
      NSDisableAutomaticTermination = true;
      NSDocumentSaveNewDocumentsToCloud = false;
      NSNavPanelExpandedStateForSaveMode = true;
      NSNavPanelExpandedStateForSaveMode2 = true;
      NSTableViewDefaultSizeMode = 2;
      NSWindowResizeTime = 1.0e-4;
      PMPrintingExpandedStateForPrint = true;
      PMPrintingExpandedStateForPrint2 = true;
    };
    LaunchServices.LSQuarantine = false;
    dock = {
      autohide = true;
      expose-animation-duration = 0.0;
      mineffect = "scale";
      minimize-to-application = true;
      mru-spaces = false;
      orientation = "bottom";
      show-recents = false;
      wvous-br-corner = 1; # Disabled
    };
    finder = {
      AppleShowAllExtensions = true;
      FXDefaultSearchScope = "SCcf";
      FXEnableExtensionChangeWarning = false;
      FXPreferredViewStyle = "Nlsv";
      ShowPathbar = true;
    };
    screencapture = {
      disable-shadow = true;
      location = "/Users/${config.my-meta.username}/Documents";
    };
    trackpad = {
      Clicking = true;
      Dragging = true;
      TrackpadRightClick = true;
      # TrackpadThreeFingerDrag = true;
    };
    loginwindow = {
      GuestEnabled = false;
      DisableConsoleAccess = true;
    };
    spaces = { spans-displays = false; };
    # Firewall
    alf = {
      globalstate = 1;
      allowsignedenabled = 1;
      allowdownloadsignedenabled = 1;
      stealthenabled = 1;
    };
  };
  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToControl = true;
  };
  system.stateVersion = 4;
}
