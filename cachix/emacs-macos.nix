{
  nix.settings = {
    substituters = [
      "https://cachix.org/api/v1/cache/emacs"
    ];

    trusted-public-keys = [
      "emacs.cachix.org-1:b1SMJNLY/mZF6GxQE+eDBeps7WnkT0Po55TAyzwOxTY="
    ];
  };
}
