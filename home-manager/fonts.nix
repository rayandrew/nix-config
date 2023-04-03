{ pkgs
, ...
}:

{
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    jetbrains-mono-nerdfont
    sf-symbols
    sf-mono-liga
    recursive
    atkinson-hyperlegible
    (nerdfonts.override { fonts = [ "FiraCode" "Ubuntu" "UbuntuMono" "CascadiaCode" ]; })
  ];

}
