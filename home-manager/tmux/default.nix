{ config, lib, pkgs, ... }:

let
  tmuxp-config = ./tmuxp;
  gitmux-config = ./gitmux.yml;
  resize-script = ./resize-adaptable.sh;
  tmuxp-variables = config.my-meta // {
    inherit tmuxp-config;
    doc = ""; # dunno why do we need this
    resize = resize-script;
  };
  one-password = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "1password";
    version = "unstable-2022-01-01";
    src = pkgs.fetchFromGitHub {
      owner = "yardnsm";
      repo = "tmux-1password";
      rev = "master";
      sha256 = "11pvwyxxkxqxyg34mcrzydz9q1wfkj1x5vx3wmy3l4p89qf2dvlk";
    };
  };
  # tokyo-night = pkgs.tmuxPlugins.mkTmuxPlugin {
  #   pluginName = "tokyo-night";
  #   version = "unstable-2022-01-01";
  #   rtpFilePath = "tokyo-night.tmux";
  #   src = pkgs.fetchFromGitHub {
  #     owner = "janoamaral";
  #     repo = "tokyo-night-tmux";
  #     rev = "master";
  #     sha256 = "sha256-QrZYdu1ulCVcmI6jRHQXmQ2EIcNU5ZHxciY3TjopT+I=";
  #   };
  # };
  # https://pablo.tools/blog/computers/nix-mustache-templates/
  templateFile = name: template: data:
    pkgs.stdenv.mkDerivation {
      name = "${name}";
      nativeBuildInpts = [ pkgs.mustache-go ];

      # Pass Json as file to avoid escaping
      passAsFile = [ "jsonData" ];
      jsonData = builtins.toJSON data;

      # Disable phases which are not needed. In particular the unpackPhase will
      # fail, if no src attribute is set
      phases = [ "buildPhase" "installPhase" ];

      buildPhase = ''
        echo $jsonDataPath
        ${pkgs.mustache-go}/bin/mustache $jsonDataPath ${template} > rendered_file
      '';

      installPhase = ''
        cp rendered_file $out
      '';
    };

in
{
  programs.tmux = {
    enable = true;
    prefix = "C-a";

    shell = "${pkgs.zsh}/bin/zsh";
    keyMode = "vi";
    clock24 = false;
    escapeTime = 500;
    historyLimit = 2000;

    baseIndex = 1;

    plugins = with pkgs; [
      tmuxPlugins.cpu
      one-password
      # tokyo-night
      {
        plugin = tmuxPlugins.resurrect;
        extraConfig = "set -g @resurrect-strategy-nvim 'session'";
      }
      { plugin = tmuxPlugins.sensible; }
      { plugin = tmuxPlugins.yank; }
      { plugin = tmuxPlugins.vim-tmux-navigator; }
    ];

    extraConfig = ''
      # setw -g aggressive-resize off
      set-option -g detach-on-destroy off
      set-option -g status-position top

      # https://github.com/folke/tokyonight.nvim#making-undercurls-work-properly-in-tmux 
      set -as terminal-overrides ',*:Smulx=\E[4::%p1%dm'  # undercurl support
      set -as terminal-overrides ',*:Setulc=\E[58::2::%p1%{65536}%/%d::%p1%{256}%/%{255}%&%d::%p1%{255}%&%d%;m'  # underscore colours - needs tmux-3.0

      setw -g automatic-rename on   # rename window to reflect current program
      set -g renumber-windows on    # renumber windows when a window is closed

      set -g set-titles on          # set terminal title

      set -g display-panes-time 800 # slightly longer pane indicators display time
      set -g display-time 1000      # slightly longer status messages display time

      set -g status-interval 10     # redraw status line every 10 seconds

      # bind -n C-l send-keys C-l \; run 'sleep 1.1' \; clear-history

      # activity
      set -g monitor-activity on
      set -g visual-activity off

      # create session
      bind C-c command-prompt -p "New Session:" "new-session -A -s '%%'"

      # kill session
      bind C-k confirm kill-session

      # reload tmux conf
      bind C-e source-file ${config.xdg.configHome}/tmux/tmux.conf

      # find session
      bind C-f command-prompt -p find-session 'switch-client -t %%'

      # create new window
      bind c new-window -c "#{pane_current_path}"

      # split current window horizontally
      bind - split-window -v -c "#{pane_current_path}"

      # split current window vertically
      bind _ split-window -h -c "#{pane_current_path}"

      # Zoxide integration
      bind-key T run-shell "t"

      # -- pane navigation -----------------------------------------------------------
      bind -r h select-pane -L  # move left
      bind -r j select-pane -D  # move down
      bind -r k select-pane -U  # move up
      bind -r l select-pane -R  # move right
      bind > swap-pane -D       # swap current pane with the next one
      bind < swap-pane -U       # swap current pane with the previous one

      # -- pane resizing -------------------------------------------------------------
      bind -r H resize-pane -L 2
      bind -r J resize-pane -D 2
      bind -r K resize-pane -U 2
      bind -r L resize-pane -R 2

      # -- window navigation ---------------------------------------------------------
      unbind n
      unbind p
      bind -r C-h previous-window # select previous window
      bind -r C-l next-window     # select next window
      bind Tab last-window        # move to last active window

      # -- copy mode -----------------------------------------------------------------

      set -g set-clipboard on

      bind Enter copy-mode # enter copy mode

      run -b 'tmux bind -t vi-copy v begin-selection 2> /dev/null || true'
      run -b 'tmux bind -T copy-mode-vi v send -X begin-selection 2> /dev/null || true'
      run -b 'tmux bind -t vi-copy C-v rectangle-toggle 2> /dev/null || true'
      run -b 'tmux bind -T copy-mode-vi C-v send -X rectangle-toggle 2> /dev/null || true'
      run -b 'tmux bind -t vi-copy y copy-selection 2> /dev/null || true'
      # run -b 'tmux bind -T copy-mode-vi y send -X copy-selection-and-cancel 2> /dev/null || true'
      run -b 'tmux bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "xclip -in -selection clipboard" 2> /dev/null || true'
      run -b 'tmux bind -t vi-copy Escape cancel 2> /dev/null || true'
      run -b 'tmux bind -T copy-mode-vi Escape send -X cancel 2> /dev/null || true'
      run -b 'tmux bind -t vi-copy H start-of-line 2> /dev/null || true'
      run -b 'tmux bind -T copy-mode-vi H send -X start-of-line 2> /dev/null || true'
      run -b 'tmux bind -t vi-copy L end-of-line 2> /dev/null || true'
      run -b 'tmux bind -T copy-mode-vi L send -X end-of-line 2> /dev/null || true'

      # -- copy to X11 clipboard ----------------------------------------------------
      if -b 'command -v xsel > /dev/null 2>&1' 'bind y run -b "tmux save-buffer - | xsel -i -b"'
      if -b '! command -v xsel > /dev/null 2>&1 && command -v xclip > /dev/null 2>&1' 'bind y run -b "tmux save-buffer - | xclip -i -selection clipboard >/dev/null 2>&1"'
      # copy to macOS clipboard
      if -b 'command -v pbcopy > /dev/null 2>&1' 'bind y run -b "tmux save-buffer - | pbcopy"'
      if -b 'command -v reattach-to-user-namespace > /dev/null 2>&1' 'bind y run -b "tmux save-buffer - | reattach-to-user-namespace pbcopy"'
      # copy to Windows clipboard
      if -b 'command -v clip.exe > /dev/null 2>&1' 'bind y run -b "tmux save-buffer - | clip.exe"'
      if -b '[ -c /dev/clipboard ]' 'bind y run -b "tmux save-buffer - > /dev/clipboard"'

      # -- buffers -------------------------------------------------------------------

      bind b list-buffers  # list paste buffers
      bind p paste-buffer  # paste from the top paste buffer
      bind P choose-buffer # choose which buffer to paste from

      # -- gitmux --------------------------------------------------------------------
      set -g status-left '#(${pkgs.unstable.gitmux}/bin/gitmux -cfg ${gitmux-config} "#{pane_current_path}")'

      # -- TokyoNight ----------------------------------------------------------------

      set -g mode-style "fg=#7aa2f7,bg=#3b4261"

      set -g message-style "fg=#7aa2f7,bg=#3b4261"
      set -g message-command-style "fg=#7aa2f7,bg=#3b4261"

      set -g pane-border-style "fg=#3b4261"
      set -g pane-active-border-style "fg=#7aa2f7"

      set -g status "on"
      set -g status-justify "left"

      set -g status-style "fg=#7aa2f7,bg=#16161e"

      set -g status-left-length "100"
      set -g status-right-length "100"

      set -g status-left-style NONE
      set -g status-right-style NONE
      
      # set -g status-left "#[fg=#15161e,bg=#7aa2f7,bold] #S #[fg=#7aa2f7,bg=#16161e,nobold,nounderscore,noitalics]"
      # set -g status-right "#[fg=#16161e,bg=#16161e,nobold,nounderscore,noitalics]#[fg=#7aa2f7,bg=#16161e] #{prefix_highlight} #[fg=#3b4261,bg=#16161e,nobold,nounderscore,noitalics]#[fg=#7aa2f7,bg=#3b4261] %Y-%m-%d  %I:%M %p #[fg=#7aa2f7,bg=#3b4261,nobold,nounderscore,noitalics]#[fg=#15161e,bg=#7aa2f7,bold] #h "
      set -g status-right "#[fg=#16161e,bg=#16161e,nobold,nounderscore,noitalics]#[fg=#7aa2f7,bg=#16161e] #{prefix_highlight} #[fg=#3b4261,bg=#16161e,nobold,nounderscore,noitalics]#[fg=#7aa2f7,bg=#3b4261] %I:%M %p #[fg=#7aa2f7,bg=#3b4261,nobold,nounderscore,noitalics]#[fg=#15161e,bg=#7aa2f7,bold] #h "
      
      setw -g window-status-activity-style "underscore,fg=#a9b1d6,bg=#16161e"
      setw -g window-status-separator ""
      setw -g window-status-style "NONE,fg=#a9b1d6,bg=#16161e"
      setw -g window-status-format "#[fg=#16161e,bg=#16161e,nobold,nounderscore,noitalics]#[default] #I  #W #F #[fg=#16161e,bg=#16161e,nobold,nounderscore,noitalics]"
      setw -g window-status-current-format "#[fg=#16161e,bg=#3b4261,nobold,nounderscore,noitalics]#[fg=#7aa2f7,bg=#3b4261,bold] #I  #W #F #[fg=#3b4261,bg=#16161e,nobold,nounderscore,noitalics]"

    '';
  };

  home.packages = with pkgs;
    [
      (writeShellScriptBin "tmuxa" ''
         #
         # tmuxa 
         #
         # Tmux create new session or attach
         #
        ${pkgs.tmux}/bin/tmux attach || ${pkgs.tmux}/bin/tmux
      '')
      unstable.gitmux
      # tmuxp # session manager ERROR: how to disable testing + checking
    ];

  xdg.configFile = {
    "tmuxp/research.yml".source =
      templateFile "research.yml" ./tmuxp/research.yml tmuxp-variables;
    "tmuxp/cl-data.yml".source =
      templateFile "cl-data.yml" ./tmuxp/cl-data.yml tmuxp-variables;
    "tmuxp/nix.yml".source =
      templateFile "nix.yml" ./tmuxp/nix.yml tmuxp-variables;
  };
}
