{ config, lib, pkgs, ... }:

let
  inherit (lib) mkAfter elem optionalString;
  inherit (config.my-meta) shellAliases;
  dataDir = "${config.xdg.dataHome}";
  # additionalZshConfig =
  #   if pkgs.stdenv.isDarwin then ''
  #     znap eval iterm2 'curl -fsSL https://iterm2.com/shell_integration/zsh'
  #   '' else ''
  #
  #   '';
in
{
  # Fish Shell
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.fish.enable
  # home.packages = with pkgs; [
  #   zsh-vi-mode
  # ];
  programs.zsh = {
    enable = true;
    shellAliases = shellAliases;
    # defaultKeymap = "viins";
    defaultKeymap = null;
    # completionInit = "";
    initExtraFirst = ''
      ZINIT_HOME="''${XDG_DATA_HOME:-''${HOME}/.local/share}/zinit/zinit.git"
      [ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
      [ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
      source "''${ZINIT_HOME}/zinit.zsh"

      zvm_config() {
        ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
        ZVM_CURSOR_STYLE_ENABLED=false
      }
      zinit light jeffreytse/zsh-vi-mode

      ## Starship Prompt
      eval "$(${pkgs.starship}/bin/starship init zsh)"

      function init_fzf() {
        [ -f ${pkgs.fzf}/share/fzf/completion.zsh ] && source ${pkgs.fzf}/share/fzf/completion.zsh
        [ -f ${pkgs.fzf}/share/fzf/key-bindings.zsh ] && source ${pkgs.fzf}/share/fzf/key-bindings.zsh
      }
      zvm_after_init_commands+=(init_fzf)

      zinit light zsh-users/zsh-history-substring-search

      # zinit ice src"zsh-edit.plugin.zsh"
      # zinit light marlonrichert/zsh-edit

      # Autosuggestions & fast-syntax-highlighting
      zinit wait lucid for \
        atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
            zdharma-continuum/fast-syntax-highlighting \
        blockf \
            zsh-users/zsh-completions \
        atload"!_zsh_autosuggest_start" \
            zsh-users/zsh-autosuggestions

      zinit ice wait"0c" lucid reset \
        atclone"local P=''${''${(M)OSTYPE:#*darwin*}:+g}
            \''${P}sed -i \
            '/DIR/c\DIR 38;5;63;1' LS_COLORS; \
            \''${P}dircolors -b LS_COLORS > c.zsh" \
        atpull'%atclone' pick"c.zsh" nocompile'!' \
        atload'zstyle ":completion:*" list-colors “''${(s.:.)LS_COLORS}”'
      zinit light trapd00r/LS_COLORS

      ZSH_AUTOSUGGEST_STRATEGY=(history completion)
      zinit light zsh-users/zsh-autosuggestions
      zinit light asdf-vm/asdf

      eval "$(${pkgs.zoxide}/bin/zoxide init zsh)"
    '';

    initExtra = mkAfter ''
      if [[ -d "${config.home.homeDirectory}/.miniconda3" ]]; then
        # >>> conda initialize >>>
        declare CONDA_PATH="${config.home.homeDirectory}/.miniconda3"
        # !! Contents within this block are managed by 'conda init' !!
        __conda_setup="$('${config.home.homeDirectory}/.miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
        if [ $? -eq 0 ]; then
          eval "$__conda_setup"
        else
          if [ -f "$CONDA_PATH/etc/profile.d/conda.sh" ]; then
            . "$CONDA_PATH/etc/profile.d/conda.sh"
          else
            path+=("$CONDA_PATH/bin:$PATH")
          fi
        fi
        unset __conda_setup
        [[ -z $TMUX ]] || conda deactivate; conda activate base
        # conda config --set changeps1 False
        # <<< conda initialize <<<
      fi

      # if [[ `uname` == "Darwin" ]]; then
      #   export LIBRARY_PATH="$LIBRARY_PATH:$(brew --prefix)/lib:$(brew --prefix)/opt/libiconv/lib"
      # fi

      # export BROWSER="browser"
      export DIRPAPERS=${config.home.homeDirectory}/Ucare/DIR-PAPERS

      # https://github.com/zshzoo/cd-ls/blob/main/cd-ls.zsh
      if ! (( $chpwd_functions[(I)chpwd_cdls] )); then
        chpwd_functions+=(chpwd_cdls)
      fi
      function chpwd_cdls() {
        if [[ -o interactive ]]; then
          emulate -L zsh
          eza -la --time-style long-iso --icons
        fi
      }
      alias kssh="kitty +kitten ssh"

      export ZK_NOTEBOOK_DIR="${config.home.homeDirectory}/zk"
      export PATH="$PATH:${config.home.homeDirectory}/.spicetify"
      export PATH="$PATH:${config.xdg.configHome}/emacs/bin"
      export CC=gcc

      if [[ `uname` == "Darwin" ]]; then
        # Herd injected PHP binary.
        export PATH="/Users/rayandrew/Library/Application Support/Herd/bin/":$PATH

        # Herd injected PHP 8.2 configuration.
        export HERD_PHP_82_INI_SCAN_DIR="/Users/rayandrew/Library/Application Support/Herd/config/php/82/"
      fi
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

  programs.eza = {
    enable = true;
    enableAliases = false;
  };
}
# vim: foldmethod=marker
