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
      "--disable-features=UseChromeOSDirectVideoDecoder"
    ];
  };
}
