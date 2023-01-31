{ ... }:

{
  imports = [
    ./direnv.nix
    ./git.nix
    ./gnupg.nix
    ./htop.nix
    ./kitty.nix
    ./meta
    ./neovim.nix
    ./nix-index.nix
    ./packages.nix
    ./ssh.nix
    ./fish.nix
    ./tmux
    ./zsh
    ./starship.nix
    ./wezterm
  ];

  systemd.user.startServices = "sd-switch";
}
