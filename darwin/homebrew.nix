{ config, lib, ... }:

let
  inherit (lib) mkIf;
  caskPresent = cask: lib.any (x: x.name == cask) config.homebrew.casks;
  brewEnabled = config.homebrew.enable;

in {
  environment.shellInit = mkIf brewEnabled ''
    eval "$(${config.homebrew.brewPrefix}/brew shellenv)"
  '';

  # https://docs.brew.sh/Shell-Completion#configuring-completions-in-fish
  # For some reason if the Fish completions are added at the end of `fish_complete_path` they don't
  # seem to work, but they do work if added at the start.
  programs.fish.interactiveShellInit = mkIf brewEnabled ''
    if test -d (brew --prefix)"/share/fish/completions"
      set -p fish_complete_path (brew --prefix)/share/fish/completions
    end

    if test -d (brew --prefix)"/share/fish/vendor_completions.d"
      set -p fish_complete_path (brew --prefix)/share/fish/vendor_completions.d
    end
  '';

  homebrew = {
    enable = true;
    onActivation = {
      # autoUpdate = true;
      cleanup = "zap";
    };
    global = { brewfile = true; };

    taps = [
      "homebrew/cask"
      "homebrew/cask-drivers"
      "homebrew/cask-fonts"
      "homebrew/cask-versions"
      "homebrew/core"
      "homebrew/services"
      "nrlquaker/createzap"
    ];

    # Prefer installing application from the Mac App Store
    masApps = {
      "1Password for Safari" = 1569813296;
      "Dark Reader for Safari" = 1438243180;
      Slack = 803453959;
    };

    # If an app isn't available in the Mac App Store, or the version in the App Store has
    # limitiations, e.g., Transmit, install the Homebrew Cask.
    casks = [
      "1password"
      "1password-cli"
      "google-drive"
      "gpg-suite"
      "loopback"
      "raycast"
      "skype"
      "visual-studio-code"
      "vlc"
      "spotify"
    ];

    # For cli packages that aren't currently available for macOS in `nixpkgs`
    brews = [
      # "mas"
    ];
  };

  # Configuration related to casks
  home-manager.users.${config.my.username}.programs.ssh =
    mkIf (caskPresent "1password-cli" && config ? home-manager) {
      enable = true;
      extraConfig = ''
        # Only set `IdentityAgent` not connected remotely via SSH.
        # This allows using agent forwarding when connecting remotely.
        Match host * exec "test -z $SSH_TTY"
          IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
      '';
    };
}
