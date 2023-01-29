{ lib, ... }:

{
  # https://github.com/NixOS/nix/issues/7273
  auto-optimise-store = lib.mkDefault true;
  trusted-users = [ "root" "@wheel" "@admin" ];
  experimental-features = [ "nix-command" "flakes" "recursive-nix" ];

  # Useful for nix-direnv, however not sure if this will
  # generate too much garbage
  # keep-outputs = true;
  # keep-derivations = true;

  system-features = [ "recursive-nix" ];

  tarball-ttl = 43200;
}
