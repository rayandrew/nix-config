{ ... }:

{
  imports = [
    ./alacritty.nix
    ./direnv.nix
    ./git.nix
    ./gnupg.nix
    ./htop.nix
    ./kitty.nix
    ./meta
    ./neovim
    ./nix-index.nix
    ./packages.nix
    ./ssh.nix
    ./fish.nix
    ./fonts.nix
    ./tmux
    ./starship.nix
    ./spotify.nix
    ./zellij
    ./zsh
    ./lazygit.nix
    ./gitui.nix
  ];

  systemd.user.startServices = "sd-switch";
}
