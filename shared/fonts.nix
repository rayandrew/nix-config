{ pkgs
, ...
}:

{
  fonts = {
    fontDir.enable = true;
    # fonts = with pkgs; [
    #   jetbrains-mono-nerdfont
    #   sf-symbols
    #   sf-mono-liga
    #   recursive
    #   (nerdfonts.override { fonts = [ "FiraCode" "Ubuntu" ]; })
    # ];
  };
}
