{ lib, pkgs, ... }:

{
  programs.kitty = lib.mkMerge [
    {
      enable = true;
      font = {
        # name = "JetBrainsMono Nerd Font";
        # name = "Pragmata Pro Mono";
        name = "UbuntuMono Nerd Font Mono";
        size = 18;
      };
      settings = {
        # https://fsd.it/shop/fonts/pragmatapro/
        # font_size = "14.0";
        adjust_line_height = "140%";
        disable_ligatures = "cursor"; # disable ligatures when cursor is on them

        # Window layout
        # hide_window_decorations = true;
        hide_window_decorations = "titlebar-only";
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
        # background_opacity = "0.96";
        # dynamic_background_opacity = "yes";
      };
      keybindings = {
        "cmd+t" = "new_tab_with_cwd";
        "ctrl+shift+c" = "copy_to_clipboard";
        "cmd+c" = "copy_to_clipboard";
        "ctrl+shift+v" = "paste_from_clipboard";
        "cmd+v" = "paste_from_clipboard";
        "shift+insert" = "paste_from_clipboard";
      };
      # theme = "Nord";
      # theme = "Tokyo Night";
      theme = "Gruvbox Dark";
      extraConfig = ''
        symbol_map U+E5FA-U+E62B,U+E700-U+E7C5,U+F000-U+F2E0,U+E200-U+E2A9,U+F500-U+FD46,U+E300-U+E3EB,U+F400-U+F4A8,U+2665,U+26A1,U+F27C,U+E0A3,U+E0B4-U+E0C8,U+E0CA,U+E0CC-U+E0D2,U+E0D4,U+23FB-U+23FE,U+2B58,U+F300-U+F313,U+E000-U+E00D JetBrainsMono Nerd Font
        symbol_map U+100000-U+10FFFF SF Pro
      '';
    }

    (lib.mkIf (pkgs.stdenv.isDarwin) {
      darwinLaunchOptions = [ "--directory=~" "--single-instance" ];
    })
  ];
}
# environment.etc."sudoers.d/kitty".text = ''
#   Defaults env_keep += "TERMINFO_DIRS"
# '';
