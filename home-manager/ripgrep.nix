{ pkgs
, config
, ...
}:

let
  home = config.home.homeDirectory;
in
{
   programs.ripgrep = {
     enable = true;
     # arguments = [
     #   "--no-heading"
     #   "--smart-case"
     # ];
   };

   home.file.".ripgreprc".text = ''
      --no-heading
      --smart-case
   '';

   programs.zsh.initExtra = ''
      export RIPGREP_CONFIG_PATH="${home}/.ripgreprc";
   '';
}
