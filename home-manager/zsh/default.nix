{ config, lib, pkgs, ... }:

let
  inherit (lib) mkAfter elem optionalString;
  inherit (config.my-meta) shellAliases;
  dataDir = "${config.xdg.dataHome}";
  homeDir = "${config.home.homeDirectory}";
  configDir = "${config.xdg.configHome}";
  p10k = ./p10k.zsh;
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
    defaultKeymap = "emacs";
    # defaultKeymap = null;
    # completionInit = "";
    initExtraFirst = ''
      ZINIT_HOME="''${XDG_DATA_HOME:-''${HOME}/.local/share}/zinit/zinit.git"
      [ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
      [ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
      source "''${ZINIT_HOME}/zinit.zsh"

      zinit ice wait'!' lucid atload'source ${p10k}; _p9k_precmd' nocd
      zinit light romkatv/powerlevel10k

      zvm_config() {
        ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
        ZVM_CURSOR_STYLE_ENABLED=false
      }
      zinit light jeffreytse/zsh-vi-mode
      zvm_after_init_commands+=(init_fzf)

      # zinit light-mode reset nocompile'!' for \
      #    blockf nocompletions compile'functions/*~*.zwc' \
      #     marlonrichert/zsh-edit

      function init_fzf() {
        [ -f ${pkgs.fzf}/share/fzf/completion.zsh ] && source ${pkgs.fzf}/share/fzf/completion.zsh
        [ -f ${pkgs.fzf}/share/fzf/key-bindings.zsh ] && source ${pkgs.fzf}/share/fzf/key-bindings.zsh
      }

      # Autosuggestions & fast-syntax-highlighting
      zinit wait lucid for \
        atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
            zdharma-continuum/fast-syntax-highlighting \
        blockf \
            zsh-users/zsh-completions \
        atload"!_zsh_autosuggest_start" \
            zsh-users/zsh-autosuggestions

      # zinit ice wait"0c" lucid reset \
      #   atclone"local P=''${''${(M)OSTYPE:#*darwin*}:+g}
      #       \''${P}sed -i \
      #       '/DIR/c\DIR 38;5;63;1' LS_COLORS; \
      #       \''${P}dircolors -b LS_COLORS > c.zsh" \
      #   atpull'%atclone' pick"c.zsh" nocompile'!' \
      #   atload'zstyle ":completion:*" list-colors “''${(s.:.)LS_COLORS}”'
      # zinit light trapd00r/LS_COLORS

      ZSH_AUTOSUGGEST_STRATEGY=(history completion)
      zinit light zsh-users/zsh-autosuggestions
      zinit light zsh-users/zsh-history-substring-search

      zinit light asdf-vm/asdf
      zinit ice wait"2" as"command" from"gh-r" lucid \
            mv"zoxide*/zoxide -> zoxide" \
            atclone"./zoxide init zsh > init.zsh" \
            atpull"%atclone" src"init.zsh" nocompile'!'
      zinit light ajeetdsouza/zoxide
      # eval "$(${pkgs.zoxide}/bin/zoxide init zsh)"
    '';

    initExtra = mkAfter ''
      # if [[ -d "${homeDir}/.miniconda3" ]]; then
      #   # >>> conda initialize >>>
      #   declare CONDA_PATH="${homeDir}/.miniconda3"
      #   # !! Contents within this block are managed by 'conda init' !!
      #   __conda_setup="$('${homeDir}/.miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
      #   if [ $? -eq 0 ]; then
      #     eval "$__conda_setup"
      #   else
      #     if [ -f "$CONDA_PATH/etc/profile.d/conda.sh" ]; then
      #       . "$CONDA_PATH/etc/profile.d/conda.sh"
      #     else
      #       path+=("$CONDA_PATH/bin:$PATH")
      #     fi
      #   fi
      #   unset __conda_setup
      #   [[ -z $TMUX ]] || conda deactivate; conda activate base
      #   # conda config --set changeps1 False
      #   # <<< conda initialize <<<
      # fi

      # >>> mamba initialize >>>
      # !! Contents within this block are managed by 'mamba init' !!
      export MAMBA_EXE="${homeDir}/.local/bin/micromamba";
      export MAMBA_ROOT_PREFIX="${homeDir}/.micromamba";
      __mamba_setup="$("$MAMBA_EXE" shell hook --shell zsh --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
      if [ $? -eq 0 ]; then
          eval "$__mamba_setup"
      else
          alias micromamba="$MAMBA_EXE"  # Fallback on help from mamba activate
      fi
      unset __mamba_setup
      # <<< mamba initialize <<<


      # if [[ `uname` == "Darwin" ]]; then
      #   export LIBRARY_PATH="$LIBRARY_PATH:$(brew --prefix)/lib:$(brew --prefix)/opt/libiconv/lib"
      # fi

      # export BROWSER="browser"
      export DIRPAPERS=${homeDir}/Ucare/DIR-PAPERS
      export ALL_PDF_FILES=${homeDir}/PDFs

      # rye
      # if [[ -f "${homeDir}/.rye/env" ]]; then
      #     source "$HOME/.rye/env"
      # fi

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

      export ZK_NOTEBOOK_DIR="${homeDir}/zk"

      export PATH="$PATH:${homeDir}/.spicetify"
      export PATH="$PATH:${configDir}/emacs/bin"
      export PATH="$PATH:${homeDir}/.local/bin"
      export PATH="$PATH:${homeDir}/.cargo/bin"

      export CC=clang

      if [[ `uname` == "Darwin" ]]; then
        # Herd injected PHP binary.
        export PATH="/Users/rayandrew/Library/Application Support/Herd/bin/":$PATH

        # Herd injected PHP 8.2 configuration.
        export HERD_PHP_82_INI_SCAN_DIR="/Users/rayandrew/Library/Application Support/Herd/config/php/82/"

        # export LDFLAGS="-L/opt/homebrew/opt/libiconv/lib $LDFLAGS"
        # export CFLAGS="-I/opt/homebrew/opt/libiconv/include $FLAGS"
        # export CPPFLAGS="-I/opt/homebrew/opt/libiconv/include $CPPFLAGS"
      fi

      ### tmux sessionizer
      ### https://github.com/ThePrimeagen/.dotfiles/blob/master/bin/.local/scripts/tmux-sessionizer
      tmux-sessionizer() {
        if [[ $# -eq 0 ]]; then
            selected=$1
        else
            selected=$(find ~/Code ~/Projects ~/Ucare ~/phd ~/Org ~/TA -mindepth 1 -maxdepth 1 -type d | fzf)
        fi

        if [[ -z $selected ]]; then
            exit 0
        fi

        selected_name=$(basename "$selected" | tr . _)
        tmux_running=$(pgrep tmux)

        if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
            tmux new-session -s $selected_name -c $selected
            exit 0
        fi

        if ! tmux has-session -t=$selected_name 2> /dev/null; then
            tmux new-session -ds $selected_name -c $selected
        fi

        tmux switch-client -t $selected_name
      }
    '';
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = false;
  };

  programs.zoxide = {
    enable = false;
    enableZshIntegration = false;
  };

  programs.eza = {
    enable = true;
    enableAliases = false;
  };
}
# vim: foldmethod=marker
