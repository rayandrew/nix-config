{ lib, pkgs, ... }:

let
  kittens = ./kittens;
  #   pass_keys = pkgs.writers.writePython3Bin "pass-keys" { libraries = [ ]; } (builtins.readFile ./kittens/pass_keys.py);
in
{
  programs.kitty = lib.mkMerge [
    {
      enable = true;
      font = {
        # name = "JetBrainsMono Nerd Font";
        # name = "Pragmata Pro Mono";
        # name = "UbuntuMono Nerd Font Mono";
        name = "JetBrainsMonoNL Nerd Font Mono";
        size = 18;
      };
      settings = {
        # https://fsd.it/shop/fonts/pragmatapro/
        # font_size = "14.0";
        adjust_line_height = "140%";
        disable_ligatures = "cursor"; # disable ligatures when cursor is on them

        # Window layout
        # hide_window_decorations = true;
        # hide_window_decorations = "titlebar-only"; # for yabai
        window_padding_width = "10";

        # Tab bar
        tab_bar_edge = "top";
        tab_bar_style = "powerline";
        tab_title_template = "Tab {index}: {title}";
        active_tab_font_style = "bold";
        inactive_tab_font_style = "normal";
        tab_activity_symbol = "";

        shell = "${pkgs.zsh}/bin/zsh";

        copy_on_select = true;
        cursor_blink_interval = 0;
        macos_option_as_alt = true;
        scrollback_pager_history_size = 1;
        update_check_interval = 0;
        editor = "${pkgs.neovim}/bin/nvim";

        # input_delay = 6;

        enabled_layouts = "splits";
        kitty_mod = "ctrl+shift";


        allow_remote_control = "yes";
        listen_on = if pkgs.stdenv.isLinux then "unix:@mykitty" else "unix:/tmp/mykitty";

        # background_opacity = "0.96";
        dynamic_background_opacity = "yes";
      };
      keybindings = {
        "cmd+t" = "new_tab_with_cwd";
        "ctrl+shift+c" = "copy_to_clipboard";
        "cmd+c" = "copy_to_clipboard";
        "ctrl+shift+v" = "paste_from_clipboard";
        "cmd+v" = "paste_from_clipboard";
        "shift+insert" = "paste_from_clipboard";

        # # tmux keybind
        # "kitty_mod+enter" = "no-op";
        # "cmd+enter" = "no-op";
        # "ctrl+a>x" = "close_window";
        # "ctrl+a>]" = "next_window";
        # "ctrl+a>[" = "previous_window";
        # "ctrl+a>period" = "move_window_forward";
        # "ctrl+a>comma" = "move_window_backward";
        # "ctrl+a>c" = "launch --cwd=last_reported --type=tab";
        # "ctrl+a>," = "set_tab_title";
        # "ctrl+a>e" = "no-op";
        # "ctrl+a>shift+e" = "launch --type=tab nvim ~/.config/kitty/kitty.conf";
        # # "ctrl+h" = "neighboring_window left";
        # # "ctrl+j" = "neighboring_window down";
        # # "ctrl+k" = "neighboring_window up";
        # # "ctrl+l" = "neighboring_window right";
        # "ctrl+j" = "kitten ${kittens}/pass_keys.py neighboring_window bottom ctrl+j \"^.* - nvim$\"";
        # "ctrl+k" = "kitten ${kittens}/pass_keys.py neighboring_window top    ctrl+k \"^.* - nvim$\"";
        # "ctrl+h" = "kitten ${kittens}/pass_keys.py neighboring_window left   ctrl+h \"^.* - nvim$\"";
        # "ctrl+l" = "kitten ${kittens}/pass_keys.py neighboring_window right  ctrl+l \"^.* - nvim$\"";
        #
        # # "ctrl+j" = "kitten pass_keys.py neighboring_window bottom";
        # # "ctrl+k" = "kitten pass_keys.py neighboring_window top   ";
        # # "ctrl+h" = "kitten pass_keys.py neighboring_window left  ";
        # # "ctrl+l" = "kitten pass_keys.py neighboring_window right ";
        #
        # "ctrl+a>h" = "neighboring_window left";
        # "ctrl+a>j" = "neighboring_window down";
        # "ctrl+a>k" = "neighboring_window up";
        # "ctrl+a>l" = "neighboring_window right";
        # "ctrl+a>shift+h" = "resize_window narrower";
        # "ctrl+a>shift+j" = "resize_window shorter";
        # "ctrl+a>shift+k" = "resize_window taller";
        # "ctrl+a>shift+l" = "resize_window wider";
        # "ctrl+a>left" = "move_window left";
        # "ctrl+a>down" = "move_window down";
        # "ctrl+a>up" = "move_window up";
        # "ctrl+a>right" = "move_window right";
        # "ctrl+a>_" = "launch --location=vsplit";
        # "ctrl+a>-" = "launch --location=hsplit";
        # "ctrl+equal" = "change_font_size all +2.0";
        # "ctrl+plus" = "change_font_size all +2.0";
        # "ctrl+kp_add" = "change_font_size all +2.0";
        # "ctrl+minus" = "change_font_size all -2.0";
        # "ctrl+kp_subtract" = "change_font_size all -2.0";
        # "ctrl+0" = "change_font_size all 0";
        # "ctrl+a>shift+r" = "combine : load_config_file : launch --type=overlay --hold --allow-remote-control kitty @ send-text \"kitty config reloaded\"";
      };
      # theme = "Nord";
      # theme = "Tokyo Night";
      # theme = "Gruvbox Dark";
      # theme = "Kaolin Breeze";
      # theme = "GitHub Light";
      # theme = "Catppuccin-Mocha";
      theme = "Catppuccin-Latte";
      extraConfig = ''
        symbol_map U+E5FA-U+E62B,U+E700-U+E7C5,U+F000-U+F2E0,U+E200-U+E2A9,U+F500-U+FD46,U+E300-U+E3EB,U+F400-U+F4A8,U+2665,U+26A1,U+F27C,U+E0A3,U+E0B4-U+E0C8,U+E0CA,U+E0CC-U+E0D2,U+E0D4,U+23FB-U+23FE,U+2B58,U+F300-U+F313,U+E000-U+E00D JetBrainsMono Nerd Font
        symbol_map U+100000-U+10FFFF SF Pro
      '';
    }

    (lib.mkIf (pkgs.stdenv.isDarwin) {
      darwinLaunchOptions = [
        "-o allow_remote_control=yes"
        "--directory=~"
        "--single-instance"
        "--listen-on unix:/tmp/mykitty"
      ];
    })
  ];



  xdg.configFile."kitty/pass_keys.py" = {
    source = "${kittens}/pass_keys.py";
  };

  xdg.configFile."kitty/neighboring_window.py" = {
    source = "${kittens}/neighboring_window.py";
  };
}
# environment.etc."sudoers.d/kitty".text = ''
#   Defaults env_keep += "TERMINFO_DIRS"
# '';
