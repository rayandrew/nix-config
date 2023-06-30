{ pkgs
, lib
, ...
}:

{
  programs.chromium = {
    enable = true;
    package = pkgs.brave;
  };
}
