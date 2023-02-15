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
      znap prompt starship

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
