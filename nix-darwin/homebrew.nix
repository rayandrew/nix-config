{ config, lib, ... }:

let
  inherit (lib) mkIf;
  brewEnabled = config.homebrew.enable;

in
{
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

  programs.zsh.interactiveShellInit = mkIf brewEnabled ''
    eval "$(${config.homebrew.brewPrefix}/brew shellenv)"
    # if test -d $(brew --prefix)
    # then
    #   FPATH="$(brew --prefix)/share/zsh/site-functions:''${FPATH}"
    # fi
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
      "d12frosted/emacs-plus"
    ];

    # Prefer installing application from the Mac App Store
    masApps = {
      "1Password for Safari" = 1569813296;
      "Dark Reader for Safari" = 1438243180;
      # Slack = 803453959;
      # "Caffeinated" = 1362171212;
      "Amphetamine" = 937984704;
      "Color Picker" = 1545870783;
      "Spf - Screen Polarizer" = 1463398888;
      "Focused Work" = 1523968394;
      "Magnet" = 441258766;
      # "Bear – Markdown Notes" = 1091189122;
    };

    # If an app isn't available in the Mac App Store, or the version in the App Store has
    # limitiations, e.g., Transmit, install the Homebrew Cask.
    casks = [
      "1password"
      "1password-cli"
      "raycast"
      "skype"
      "vlc"
      "spotify"
      "neovide" # Neovim GUI
      "alt-tab"
      "forklift" # sftp client
      "zoom"
      "pdf-expert"
      "slack"
      "notion"
      "multipass"
      "zotero"

      # r
      "r"
      "rstudio"

      "logseq"

      "nextcloud"
      # "ferdium"

      "bitwarden"

      "trilium-notes"

      "eloston-chromium"

      "nordvpn"
      # "thunderbird"

      "whatsapp"
    ];

    # For cli packages that aren't currently available for macOS in `nixpkgs`
    brews = [
      "libiconv"
      "libomp"
      {
        name = "emacs-plus@29";
        args = [
          "with-dbus"
          "with-cocoa"
          "with-debug"
          "with-native-comp"
        ];
      }
      # "emacs-plus@29"
      # "macvim"
      # "emacs-plus@29"
      # "cherrytree"
      # "mas"
    ];
  };

}
