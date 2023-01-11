{ config, lib, pkgs, ... }:

if builtins.hasAttr "hm" lib then

{
  programs.kitty.enable = true;
  programs.kitty.darwinLaunchOptions = [
    "--single-instance"
    "--directory=~"
  ];
  programs.kitty.font.name = "JetBrainsMono Nerd Font";
  programs.kitty.font.size = 15;
  programs.kitty.settings = {
    # https://fsd.it/shop/fonts/pragmatapro/
    font_family = "PragmataPro Mono Liga";
    font_size = "14.0";
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
  };
  # programs.kitty.theme = "Nord";
  programs.kitty.theme = "Tokyo Night";
  programs.kitty.extraConfig = ''
    # symbol_map U+E5FA-U+E62B,U+E700-U+E7C5,U+F000-U+F2E0,U+E200-U+E2A9,U+F500-U+FD46,U+E300-U+E3EB,U+F400-U+F4A8,U+2665,U+26A1,U+F27C,U+E0A3,U+E0B4-U+E0C8,U+E0CA,U+E0CC-U+E0D2,U+E0D4,U+23FB-U+23FE,U+2B58,U+F300-U+F313,U+E000-U+E00D JetBrainsMono Nerd Font
    # symbol_map U+100000-U+10FFFF SF Pro
  '';
  programs.zsh.initExtra = ''
    # kitty shell integration
    if [[ -n $KITTY_INSTALLATION_DIR ]]; then
      export KITTY_SHELL_INTEGRATION="enabled"
      autoload -Uz -- "$KITTY_INSTALLATION_DIR"/shell-integration/zsh/kitty-integration
      kitty-integration
      unfunction kitty-integration
    fi
  '';
}

else

{
  environment.etc."sudoers.d/kitty".text = ''
    Defaults env_keep += "TERMINFO_DIRS"
  '';
}
