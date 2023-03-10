{ pkgs
, config
, ...
}:

let
  configDir =
    if pkgs.stdenv.isDarwin then
      "Library/Application Support/org.Zellij-Contributors.Zellij"
    else
      "${config.xdg.configHome}/zellij";
in
{
  programs.zellij = {
    enable = true;
  };

  home.file."${configDir}/config.kdl".source = ./config.kdl;
}
