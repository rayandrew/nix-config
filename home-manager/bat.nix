{ pkgs
, lib
, ...
}:

let
  flavor = "mocha";
in
{
  programs.bat = {
    enable = true;
    config = {
      theme = "catppuccin-${flavor}";
    };
    extraPackages = with pkgs.bat-extras; lib.mkIf (pkgs.stdenv.isDarwin) [
      batdiff
      batman
      batgrep
      batwatch
    ];
    themes = {
      "catppuccin-${flavor}" = builtins.readFile (pkgs.fetchFromGitHub
        {
          owner = "catppuccin";
          repo = "bat"; # Bat uses sublime syntax for its themes
          rev = "ba4d16880d63e656acced2b7d4e034e4a93f74b1";
          sha256 = "sha256-6WVKQErGdaqb++oaXnY3i6/GuH2FhTgK0v4TN4Y0Wbw=";
        } + "/Catppuccin-${flavor}.tmTheme");
    };
  };
}
