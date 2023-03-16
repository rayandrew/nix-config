{ flake, ... }:

{
  imports = [
    flake.inputs.nixvim.homeManagerModules.nixvim
    ./alacritty.nix
    ./direnv.nix
    ./git.nix
    ./gnupg.nix
    ./htop.nix
    ./meta
    ./neovim
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
  ];

  systemd.user.startServices = "sd-switch";
}
