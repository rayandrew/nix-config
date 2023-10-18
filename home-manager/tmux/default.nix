{ config, lib, pkgs, ... }:

let
  inherit (config.my-meta) backgroundColor foregroundColor;

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
    rtpFilePath = "plugin.tmux";
    src = pkgs.fetchFromGitHub {
      owner = "yardnsm";
      repo = "tmux-1password";
      rev = "master";
      sha256 = "11pvwyxxkxqxyg34mcrzydz9q1wfkj1x5vx3wmy3l4p89qf2dvlk";
    };
  };
  # gruvbox = pkgs.tmuxPlugins.mkTmuxPlugin {
  #   pluginName = "gruvbox";
  #   version = "unstable-2023-06-26";
  #   # rtpFilePath = "plugin.tmux";
  #   src = pkgs.fetchFromGitHub {
  #     owner = "egel";
  #     repo = "tmux-gruxbox";
  #     rev = "3f9e38d7243179730b419b5bfafb4e22b0a969ad";
  #     sha256 = "sha256-jvGCrV94vJroembKZLmvGO8NknV1Hbgz2IuNmc/BE9A=";
  #   };
  # };
  catppuccin = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "catppuccin";
    version = "unstable-2023-04-25";
    src = pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "tmux";
      rev = "4e48b09a76829edc7b55fbb15467cf0411f07931";
      sha256 = "sha256-bXEsxt4ozl3cAzV3ZyvbPsnmy0RAdpLxHwN82gvjLdU=";
    };
    postInstall = ''
      sed -i -e 's|''${PLUGIN_DIR}/catppuccin-selected-theme.tmuxtheme|''${TMUX_TMPDIR}/catppuccin-selected-theme.tmuxtheme|g' $target/catppuccin.tmux
    '';
    meta = with lib; {
      homepage = "https://github.com/catppuccin/tmux";
      description = "Soothing pastel theme for Tmux!";
      license = licenses.mit;
      platforms = platforms.unix;
      maintainers = with maintainers; [ jnsgruk ];
    };
  };

  # tomorrow = pkgs.fetchFromGitHub {
  #   owner = "edouard-lopez";
  #   repo = "tmux-tomorrow";
  #   rev = "680cf511315793efaa4c0af31b2ab0f06bebb485";
  #   sha256 = "sha256-GlzbP61nIqnEBKpNiDpTRTCMH1k4uknBRXjotgLoq6o=";
  # };

  # backgroundColor = "#fafafa";
  # foregroundColor = "#575f66";

  # gruvbox
  # backgroundColor = "#282828";
  # foregroundColor = "#ebdbb2";
in
{
  programs.tmux = {
    enable = true;
    # prefix = if (config.device.type == "server") then "C-Space" else "C-a";
    prefix = "C-Space";

    terminal = "screen-256color";
    shell = "${pkgs.zsh}/bin/zsh";
    keyMode = "vi";
    clock24 = false;
    escapeTime = 500;
    historyLimit = 2000;
    mouse = true;
    baseIndex = 1;

    plugins = with pkgs; [
      tmuxPlugins.cpu
      {
        plugin = one-password;
        extraConfig = ''
          # set -g @1password-debug 'on'
          set -g @1password-key 'P'
        '';
      }
      # tokyo-night
      {
        plugin = tmuxPlugins.resurrect;
        extraConfig = "set -g @resurrect-strategy-nvim 'session'";
      }
      { plugin = tmuxPlugins.sensible; }
      { plugin = tmuxPlugins.yank; }
      # { plugin = tmuxPlugins.vim-tmux-navigator; }
      # {
      #   plugin = tmuxPlugins.power-theme;
      #   extraConfig = ''
      #     set -g @tmux_power_theme 'snow'
      #   '';
      # }
      # {
      #   plugin = tmuxPlugins.gruvbox;
      #   extraConfig = ''
      #     set -g @tmux-gruvbox 'light'
      #   '';
      # }
      # {
      #   plugin = catppuccin;
      #   extraConfig = ''
      #     set -g @catppuccin_flavour 'macchiato' # or frappe, macchiato, mocha"
      #     set -g @catppuccin_window_tabs_enabled on
      #     set -g @catppuccin_left_separator "█"
      #     set -g @catppuccin_right_separator "█"
      #     # set -g @catppuccin_date_time "%Y-%m-%d %H:%M"
      #     set -g @catppuccin_date_time "%H:%M"
      #     # set -g @catppuccin_user "on"
      #     # set -g @catppuccin_host "on"
      #   '';
      # }
    ];

    extraConfig = ''
      # setw -g aggressive-resize off
      set-option -g detach-on-destroy off
      set-option -g status-position bottom # top

      # set -g default-terminal "screen-256color"
      set -ga terminal-overrides ",xterm-256color*:Tc"

      # https://github.com/folke/tokyonight.nvim#making-undercurls-work-properly-in-tmux
      set -as terminal-overrides ',*:Smulx=\E[4::%p1%dm'  # undercurl support
      set -as terminal-overrides ',*:Setulc=\E[58::2::%p1%{65536}%/%d::%p1%{256}%/%{255}%&%d::%p1%{255}%&%d%;m'

      setw -g automatic-rename on   # rename window to reflect current program
      set -g renumber-windows on    # renumber windows when a window is closed

      set -g set-titles on          # set terminal title

      set -g display-panes-time 800 # slightly longer pane indicators display time
      set -g display-time 1000      # slightly longer status messages display time

      # bind -n C-l send-keys C-l \; run 'sleep 1.1' \; clear-history

      # activity
      set -g monitor-activity on
      set -g visual-activity off

      # create session
      bind C-c command-prompt -p "New Session:" "new-session -A -s '%%'"

      # kill session
      bind C-k confirm kill-session

      # reload tmux conf
      # bind C-e source-file ${config.xdg.configHome}/tmux/tmux.conf
      bind r source-file ${config.xdg.configHome}/tmux/tmux.conf

      # find session
      bind C-f command-prompt -p find-session 'switch-client -t %%'

      # create new window
      bind c new-window -c "#{pane_current_path}"

      # split current window horizontally
      bind - split-window -v -c "#{pane_current_path}"

      # split current window vertically
      bind _ split-window -h -c "#{pane_current_path}"

      # Zoxide integration
      bind-key t run-shell "t"

      # Tmux Sessionizer
      bind-key o run-shell "${pkgs.tmux-sessionizer}/bin/tms"

      # pane navigation
      bind -r h select-pane -L  # move left
      bind -r j select-pane -D  # move down
      bind -r k select-pane -U  # move up
      bind -r l select-pane -R  # move right
      bind > swap-pane -D       # swap current pane with the next one
      bind < swap-pane -U       # swap current pane with the previous one

      # pane resizing
      bind -r H resize-pane -L 2
      bind -r J resize-pane -D 2
      bind -r K resize-pane -U 2
      bind -r L resize-pane -R 2

      # window navigation
      unbind n
      unbind p
      bind -r C-h previous-window # select previous window
      bind -r C-l next-window     # select next window
      bind Tab last-window        # move to last active window

      # copy mode
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

      # copy to X11 clipboard
      if -b 'command -v xsel > /dev/null 2>&1' 'bind y run -b "tmux save-buffer - | xsel -i -b"'
      if -b '! command -v xsel > /dev/null 2>&1 && command -v xclip > /dev/null 2>&1' 'bind y run -b "tmux save-buffer - | xclip -i -selection clipboard >/dev/null 2>&1"'
      # copy to macOS clipboard
      if -b 'command -v pbcopy > /dev/null 2>&1' 'bind y run -b "tmux save-buffer - | pbcopy"'
      if -b 'command -v reattach-to-user-namespace > /dev/null 2>&1' 'bind y run -b "tmux save-buffer - | reattach-to-user-namespace pbcopy"'
      # copy to Windows clipboard
      if -b 'command -v clip.exe > /dev/null 2>&1' 'bind y run -b "tmux save-buffer - | clip.exe"'
      if -b '[ -c /dev/clipboard ]' 'bind y run -b "tmux save-buffer - > /dev/clipboard"'

      # status line
      set -g status "on"
      set -g status-justify "left"

      set -g status-left-length "100"
      set -g status-right-length "100"

      set -g status-left-style NONE
      set -g status-right-style NONE

      # set -g status-style bg=default
      set -g status-right "#H"
      # set -g status-interval 10     # redraw status line every 10 seconds

      # https://github.com/christoomey/vim-tmux-navigator
      # disable wrapping
      is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
      | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|l?n?vim?x?)(diff)?$'"
      bind-key -n 'C-h' if-shell "$is_vim" { send-keys C-h } { if-shell -F '#{pane_at_left}'   {} { select-pane -L } }
      bind-key -n 'C-j' if-shell "$is_vim" { send-keys C-j } { if-shell -F '#{pane_at_bottom}' {} { select-pane -D } }
      bind-key -n 'C-k' if-shell "$is_vim" { send-keys C-k } { if-shell -F '#{pane_at_top}'    {} { select-pane -U } }
      bind-key -n 'C-l' if-shell "$is_vim" { send-keys C-l } { if-shell -F '#{pane_at_right}'  {} { select-pane -R } }

      bind-key -T copy-mode-vi 'C-h' if-shell -F '#{pane_at_left}'   {} { select-pane -L }
      bind-key -T copy-mode-vi 'C-j' if-shell -F '#{pane_at_bottom}' {} { select-pane -D }
      bind-key -T copy-mode-vi 'C-k' if-shell -F '#{pane_at_top}'    {} { select-pane -U }
      bind-key -T copy-mode-vi 'C-l' if-shell -F '#{pane_at_right}'  {} { select-pane -R }
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
      tmux-sessionizer
      # tmuxp # session manager ERROR: how to disable testing + checking
    ];

  # xdg.configFile = {
  #   "tmuxp/research.yml".source =
  #     templateFile "research.yml" ./tmuxp/research.yml tmuxp-variables;
  #   "tmuxp/cl-data.yml".source =
  #     templateFile "cl-data.yml" ./tmuxp/cl-data.yml tmuxp-variables;
  #   "tmuxp/nix.yml".source =
  #     templateFile "nix.yml" ./tmuxp/nix.yml tmuxp-variables;
  # };
}
