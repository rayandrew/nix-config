{ pkgs
, lib
, ...
}:

{
  programs.chromium = {
    enable = false;
    # package = pkgs.brave-cross;
    commandLineArgs = [
      "--use-gl=egl"
      # "--disable-features=UseChromeOSDirectVideoDecoder"
      "--enable-features=UseOzonePlatform"
      # "--ozone-platform=wayland"
      "--ozone-platform-hint=auto"
    ];
  };
}
