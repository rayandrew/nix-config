{ pkgs
, lib
, ...

}:

{
  programs.vivaldi = {
    enable = true;
    package = pkgs.vivaldi-cross;
  };
}
