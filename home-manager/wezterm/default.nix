{ pkgs, ... }:

{
  programs.wezterm = {
    enable = false;
    colorSchemes = {
      # GPT3 license
      # modified from https://github.com/frdwin/everforest-for-wezterm/blob/main/everforest-dark-hard.toml
      everforest-dark-hard = {
        background = "#272e33";
        cursor_bg = "#d3c6aa";
        cursor_border = "#d3c6aa";
        cursor_fg = "#272e33";
        foreground = "#d3c6aa";
        ansi = [
          "#414b50"
          "#e67e80"
          "#a7c080"
          "#dbbc7f"
          "#7fbbb3"
          "#d699b6"
          "#83c092"
          "#d3c6aa"
        ];
        brights = [
          "#475258"
          "#e67e80"
          "#a7c080"
          "#dbbc7f"
          "#7fbbb3"
          "#d699b6"
          "#83c092"
          "#d3c6aa"
        ];
      };
    };
    # package = pkgs.stable.wezterm;
    extraConfig = builtins.readFile ./config.lua;
  };
}
