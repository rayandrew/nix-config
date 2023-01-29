{
  nix.settings = {
    substituters = [ "https://rayandrew-nix-config.cachix.org" ];
    trusted-public-keys = [
      "rayandrew-nix-config.cachix.org-1:on0ZZRm+vpJW+D4vv5NxHamNRIRwjQovpckETxz7MYs="
    ];
  };
}
