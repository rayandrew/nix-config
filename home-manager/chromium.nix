{ pkgs
, lib
, ...
}:

{
  programs.chromium = {
    enable = true;
    package = pkgs.brave;
    commandLineArgs = [
      "--use-gl=egl"
      # "--disable-features=UseChromeOSDirectVideoDecoder"
      "--enable-features=UseOzonePlatform"
      # "--ozone-platform=wayland"
      "--ozone-platform-hint=auto"
    ];
  };
}
