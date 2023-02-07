{ pkgs, ... }:

{
  imports = [ ./default.nix ];

  home.packages = with pkgs; [ parted xclip conda ];
}
