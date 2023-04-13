{ pkgs
, lib
, ...
}:

{
  imports = [
    ../modules/darwin/sketchyvim
  ];

  services.sketchyvim = {
    enable = true;
    package = pkgs.sketchyvim;
    config = ''
      noremap ß $
      nmap <C-k> <Esc>:m .+1<CR>==gn
      nmap <C-l> <Esc>:m .-2<CR>==gn
    '';
    blacklist = [
      "Alacritty"
      "iTerm2"
      "Kitty"
      "MacVim"
      "Neovide"
      "Terminal"
      "Sidekick"
    ];
  };
}
