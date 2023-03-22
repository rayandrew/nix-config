{ config
, lib
, pkgs
, ...
}:

{
  services.emacs = {
    enable = false;
    package = pkgs.emacsGit;
    additionalPath = [
      "${pkgs.gzip}/bin"
    ];
  };
}
