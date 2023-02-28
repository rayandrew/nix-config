{
  cancelPreviousRuns = {
    name = "Cancel Previous Runs";
    uses = "styfle/cancel-workflow-action@0.11.0";
  };
  maximimizeBuildSpaceStep = {
    uses = "easimon/maximize-build-space@v6";
    "with" = {
      remove-dotnet = true;
      remove-android = true;
      remove-haskell = true;
      overprovision-lvm = true;
    };
  };
  checkoutStep = { uses = "actions/checkout@v3"; };
  installNixActionStep = { channel ? "nixos-unstable" }: {
    uses = "cachix/install-nix-action@v19";
    "with" = {
      # Need to define a channel, otherwise it wiill use bash from environment
      nix_path = "nixpkgs=channel:${channel}";
      # Should avoid GitHub API rate limit
      extra_nix_config = "access-tokens = github.com=\${{ secrets.GITHUB_TOKEN }}";
    };
  };
  cachixActionStep = {
    uses = "cachix/cachix-action@v12";
    "with" = {
      name = "rayandrew-nix-config";
      extraPullNames = "nix-community";
      authToken = "\${{ secrets.CACHIX_AUTH_TOKEN }}";
    };
  };
  setDefaultGitBranchStep = {
    name = "Set default git branch (to reduce log spam)";
    run = "git config --global init.defaultBranch main";
  };
  checkNixStep = {
    name = "Check if all `.nix` files are formatted correctly";
    run = "nix run '.#formatCheck'";
    # run = "nix-store --repair --verify --check-contents && nix build '.#formatCheck' && ./result/bin/formatCheck";
    # env = {
    #   NIX_LOG_DIR = "$TMPDIR";
    #   NIX_STATE_DIR = "$TMPDIR";
    # };
  };
  validateFlakesStep = {
    name = "Validate Flakes";
    run = "nix flake check";
  };
  buildHomeManagerConfigurations = hostnames: {
    name = "Build Home-Manager configs";
    run = builtins.concatStringsSep "\n" (map
      (hostname:
        "nix build '.#homeConfigurations.${hostname}.activationPackage'")
      hostnames);
  };
  buildNixOSConfigurations = hostnames: {
    name = "Build NixOS configs";
    run = builtins.concatStringsSep "\n" (map
      (hostname:
        "nix build '.#nixosConfigurations.${hostname}.config.system.build.toplevel'")
      hostnames);
  };
  buildNixDarwinConfigurations = hostnames: {
    name = "Build Nix Darwin configs";
    run = builtins.concatStringsSep "\n"
      (map (hostname: "nix build '.#darwinConfigurations.${hostname}.system'")
        hostnames);
  };
  updateFlakeLockStep = {
    name = "Update flake.lock";
    run = ''
      git config user.name "''${{ github.actor }}"
      git config user.email "''${{ github.actor }}@users.noreply.github.com"
      nix flake update --commit-lock-file
    '';
  };
  createPullRequestStep = {
    name = "Create Pull Request";
    uses = "peter-evans/create-pull-request@v4";
    "with" = {
      branch = "flake-updates";
      delete-branch = true;
      title = "Update flake.lock";
      body = ''
        ## Run report
        https://github.com/''${{ github.repository }}/actions/runs/''${{ github.run_id }}
      '';
    };
  };
}
