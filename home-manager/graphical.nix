{ pkgs, ... }:

# let
#   defaultModules = [
#     ./wezterm
#   ];
#   _nixosModules = [ ];
#   nixosModules = if (pkgs.stdenv.isLinux) then _nixosModules else [ ];
#   _darwinModules = [ ];
#   darwinModules = if (pkgs.stdenv.isDarwin) then _darwinModules else [ ];
# in
{
  imports = [
    ./wezterm
    ./vscode.nix
    ./fonts.nix
    ./kitty
    ./firefox
    ./obsidian
    ./chromium.nix
    # ./vivaldi.nix
  ];

  home.packages = with pkgs; [
    # mypaint
    # lorien
  ] ++ lib.optionals pkgs.stdenv.isDarwin [
    # krita
  ] ++ lib.optionals pkgs.stdenv.isLinux [
    _1password-gui
    skypeforlinux
    # citrix_workspace
    slack
    steam-run
  ];
}
