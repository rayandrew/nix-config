{ pkgs
, ...
}:

{
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    sf-symbols
    sf-mono-liga
    recursive
    atkinson-hyperlegible
    (nerdfonts.override {
      fonts = [
        "FiraCode"
        "Ubuntu"
        "UbuntuMono"
        "CascadiaCode"
        "Iosevka"
        "IosevkaTerm"
        "IntelOneMono"
        "JetBrainsMono"
        "Hack"
        "iA-Writer"
      ];
    })
    sketchybar-app-font
    iosevka-comfy.comfy
    iosevka-comfy.comfy-wide
    iosevka-comfy.comfy-motion
    iosevka-comfy.comfy-wide-motion
  ];

}
