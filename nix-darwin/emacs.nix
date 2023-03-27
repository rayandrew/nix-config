{ config
, lib
, pkgs
, ...
}:

{
  services.emacs = {
    enable = false;
    package = pkgs.emacsUnstable;
    additionalPath = [
      "${pkgs.gzip}/bin"
    ];
  };
}
