{ flake, pkgs, ... }:

{
  imports = [
    flake.inputs.nixvim.homeManagerModules.nixvim
    ./default.nix
  ];

  home.packages = with pkgs; [ parted xclip conda ];
}
