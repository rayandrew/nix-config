{ pkgs
, config
, ...
}:

let
  configDir = "${config.xdg.configHome}";
in
{
  home.packages = with pkgs; [
    ranger
  ];

  home.file."${configDir}/ranger/rc.conf".text = ''
    set preview_images true
    set preview_images_method kitty
  '';
}
