{ flake, ... }:

{
  imports = [
    flake.inputs.nixvim.homeManagerModules.nixvim
    ./alacritty.nix
    ./direnv.nix
    ./git
    ./gnupg.nix
    ./htop.nix
    ./meta
    ./neovim
    ./emacs
    ./nix-index.nix
    ./packages.nix
    ./ssh.nix
    ./fish.nix
    ./tmux
    ./starship.nix
    ./spotify.nix
    ./zellij
    ./zsh
    ./lazygit.nix
    ./gitui.nix
    ./lf
    ./bat.nix
    ./ripgrep.nix
  ];

  systemd.user.startServices = "sd-switch";
}
