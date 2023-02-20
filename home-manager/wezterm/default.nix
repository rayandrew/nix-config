{ pkgs, ... }:

{
  programs.wezterm = {
    enable = true;
    colorSchemes = { };
    # package = pkgs.stable.wezterm;
    extraConfig = builtins.readFile ./config.lua;
  };
}
