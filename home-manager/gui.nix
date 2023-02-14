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
  ];

  home.packages = with pkgs; [ ];
}
