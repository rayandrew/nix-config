{ config, lib, pkgs, ... }:

let
  inherit (lib) mkAfter elem optionalString;
  inherit (config.my-meta) shellAliases;
  dataDir = "${config.xdg.dataHome}";
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
      # zmodload zsh/zprof

      [[ -f ${dataDir}/zsh-snap/znap.zsh ]] ||
        git clone --depth 1 -- \
        https://github.com/marlonrichert/zsh-snap.git ${dataDir}/zsh-snap

      [[ -d ${dataDir}/zsh-snap/pkgs ]]  ||
        mkdir -p ${dataDir}/zsh-snap/pkgs

      zstyle ':znap:*' repos-dir ${dataDir}/zsh-snap/pkgs
      source "${dataDir}/zsh-snap/znap.zsh"

      zvm_config() {
        ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
        ZVM_CURSOR_STYLE_ENABLED=false
      }
      znap source jeffreytse/zsh-vi-mode

      ## Starship Prompt
      znap eval starship "${pkgs.starship}/bin/starship init zsh"
      znap prompt

      function init_fzf() {
        [ -f ${pkgs.fzf}/share/fzf/completion.zsh ] && source ${pkgs.fzf}/share/fzf/completion.zsh
        [ -f ${pkgs.fzf}/share/fzf/key-bindings.zsh ] && source ${pkgs.fzf}/share/fzf/key-bindings.zsh
      }
      zvm_after_init_commands+=(init_fzf)

      znap source zsh-users/zsh-history-substring-search
      # znap source marlonrichert/zsh-autocomplete
      znap source marlonrichert/zsh-edit
      znap source zdharma-continuum/fast-syntax-highlighting

      ZSH_AUTOSUGGEST_STRATEGY=(history completion)
      znap source zsh-users/zsh-autosuggestions

      znap source asdf-vm/asdf

      znap eval zoxide "${pkgs.zoxide}/bin/zoxide init zsh"
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

      if [[ `uname` == "Darwin" ]]; then
        export LIBRARY_PATH="$LIBRARY_PATH:$(brew --prefix)/lib:$(brew --prefix)/opt/libiconv/lib"
      fi

      # export BROWSER="browser"
      export DIRPAPERS=${config.home.homeDirectory}/Ucare/DIR-PAPERS

      # https://github.com/zshzoo/cd-ls/blob/main/cd-ls.zsh
      if ! (( $chpwd_functions[(I)chpwd_cdls] )); then
        chpwd_functions+=(chpwd_cdls)
      fi
      function chpwd_cdls() {
        if [[ -o interactive ]]; then
          emulate -L zsh
          ${pkgs.exa}/bin/exa -la --time-style long-iso --icons
        fi
      }
      alias kssh="kitty +kitten ssh"

      # catppuccin mocha
      # export FZF_DEFAULT_OPTS=" \
      # --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
      # --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
      # --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"
      
      # catppuccin latte
      # export FZF_DEFAULT_OPTS=" \
      #   --color=bg+:#ccd0da,bg:#eff1f5,spinner:#dc8a78,hl:#d20f39 \
      #   --color=fg:#4c4f69,header:#d20f39,info:#8839ef,pointer:#dc8a78 \
      #   --color=marker:#dc8a78,fg+:#4c4f69,prompt:#8839ef,hl+:#d20f39"
      
      # catppuccin macchiato
      # export FZF_DEFAULT_OPTS=" \
      #   --color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796 \
      #   --color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6 \
      #   --color=marker:#f4dbd6,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796"

      export ZK_NOTEBOOK_DIR="${config.home.homeDirectory}/zk"
      export PATH="$PATH:${config.home.homeDirectory}/.spicetify"
      export PATH="$PATH:${config.xdg.configHome}/emacs/bin"
      export CC=gcc
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

  programs.exa = {
    enable = true;
    enableAliases = false;
  };
}
# vim: foldmethod=marker
