{ ... }:

{
  programs.wezterm = {
    enable = true;
    colorSchemes = { };
    extraConfig = builtins.readFile ./config.lua;
  };
}
