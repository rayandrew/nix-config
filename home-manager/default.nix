{ ... }:

{
  imports = [
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
    ./zellij.nix
    ./zsh
  ];

  systemd.user.startServices = "sd-switch";
}
