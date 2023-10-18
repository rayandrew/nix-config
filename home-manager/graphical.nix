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
    # ./firefox
    ./obsidian
    ./chromium.nix
    # ./vivaldi.nix
  ];

  home.packages = with pkgs; [
    # _1password-gui
    # mypaint
    # lorien
  ] ++ lib.optionals pkgs.stdenv.isDarwin [
    # krita
  ] ++ lib.optionals pkgs.stdenv.isLinux [
    skypeforlinux
    # citrix_workspace
    slack
  ];
}
