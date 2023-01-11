{ config, lib, pkgs, ... }:

let
  inherit (lib) mkAfter elem optionalString;
  inherit (config.my) shellAliases directory;
  scripts = ./scripts;
  dataDir = "${config.xdg.dataHome}";
in {
  # Fish Shell
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.fish.enable
  # home.packages = with pkgs; [
  #   zsh-vi-mode
  # ];
  programs.zsh = {
    enable = true;
    shellAliases = shellAliases;
    defaultKeymap = "viins";
    completionInit = "";
    # zplug = {
    #   enable = true;
    #   plugins = [
    #     { name = "zsh-users/zsh-autosuggestions"; tags = [  ]; }
    #     { name = "zsh-users/zsh-syntax-highlighting"; tags = [  ]; }
    #     { name = "hlissner/zsh-autopair"; tags = [  ]; }
    #     { name = "marlonrichert/zsh-edit"; tags = [  ]; }
    #     { name = "jeffreytse/zsh-vi-mode"; tags = [  ]; }
    #     { name = "plugins/git"; tags = [ from:oh-my-zsh  ]; }
    #   ];
    # };
    # oh-my-zsh = {
    #   enable = true;
    #   plugins = [
    #     "asdf"
    #     "aliases"
    #     "bundler"
    #     "dotenv"
    #     "git"
    #     "macos"
    #     "rake"
    #     "rbenv"
    #     "ruby"
    #     "z"
    #   ];
    # };

    initExtraFirst = ''
      # zmodload zsh/zprof

      [[ -f ${dataDir}/zsh-snap/znap.zsh ]] ||
        git clone --depth 1 -- \
        https://github.com/marlonrichert/zsh-snap.git ${dataDir}/zsh-snap

      [[ -d ${dataDir}/zsh-snap/pkgs ]]  ||
        mkdir -p ${dataDir}/zsh-snap/pkgs

      zstyle ':znap:*' repos-dir ${dataDir}/zsh-snap/pkgs
      source "${dataDir}/zsh-snap/znap.zsh"

      ## Starship Prompt
      # export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/config.toml"
      znap eval starship "${pkgs.starship}/bin/starship init zsh"
      znap prompt starship

      # znap source ohmyzsh/ohmyzsh lib/{git,theme-and-appearance}
      # znap prompt ohmyzsh/ohmyzsh robbyrussell

      ZVM_CURSOR_STYLE_ENABLED=false
      znap source jeffreytse/zsh-vi-mode
      zvm_after_init_commands+=("[ -f ${pkgs.fzf}/share/fzf/completion.zsh ] && source ${pkgs.fzf}/share/fzf/completion.zsh")
      zvm_after_init_commands+=("[ -f ${pkgs.fzf}/share/fzf/key-bindings.zsh ] && source ${pkgs.fzf}/share/fzf/key-bindings.zsh")

      # znap source marlonrichert/zsh-autocomplete
      znap source marlonrichert/zsh-edit

      # ZSH_AUTOSUGGEST_STRATEGY=( history )
      znap source zsh-users/zsh-autosuggestions

      # ZSH_HIGHLIGHT_HIGHLIGHTERS=(main)
      typeset -A ZSH_HIGHLIGHT_STYLES
      ZSH_HIGHLIGHT_STYLES[cursor]='bg-blue underline'
      znap source zsh-users/zsh-syntax-highlighting

      # znap install ohmyzsh/ohmyzsh
      # plugins=(
      #   # asdf
      #   aliases
      #   bundler
      #   dotenv
      #   git
      #   macos
      # )
      # znap source ohmyzsh/ohmyzsh # might be slow

      znap eval zoxide "${pkgs.zoxide}/bin/zoxide init zsh"
    '';

    initExtra = mkAfter ''
      # zprof 
    '';
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = false;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = false;
  };
}
# vim: foldmethod=marker
