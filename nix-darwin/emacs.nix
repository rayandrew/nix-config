{ config
, lib
, pkgs
, ...
}:

{
  services.emacs = {
    enable = true;
    package = pkgs.emacsGit;
    additionalPath = [
      "${pkgs.gzip}/bin"
    ];
  };
}
