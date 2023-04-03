{ pkgs
, lib
, ...
}:

{
  home.packages = with pkgs; [
    unstable.obsidian
    pdfannots2json
  ];
}
