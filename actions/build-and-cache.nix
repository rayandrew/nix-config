let
  steps = import ./steps.nix;
  constants = import ./constants.nix;
in
with constants; {
  name = "build-and-cache";
  on = [ "push" "workflow_dispatch" ];
  jobs = {
    build-linux = {
      inherit (ubuntu) runs-on;
      steps = with steps; [
        cancelPreviousRuns
        maximimizeBuildSpaceStep
        checkoutStep
        (installNixActionStep { })
        cachixActionStep
        setDefaultGitBranchStep
        # checkNixStep # FIXME: dunno why this cannot run
        validateFlakesStep
        (buildHomeManagerConfigurations home-manager.linux.hostnames)
        (buildNixOSConfigurations nixos.hostnames)
      ];
    };
    build-macos = {
      inherit (constants.macos) runs-on;
      steps = with steps; [
        cancelPreviousRuns
        checkoutStep
        (installNixActionStep { channel = "nixpkgs-unstable"; })
        cachixActionStep
        setDefaultGitBranchStep
        # checkNixStep
        # validateFlakesStep
        (buildHomeManagerConfigurations home-manager.darwin.hostnames)
        (buildNixDarwinConfigurations nix-darwin.hostnames)
      ];
    };
  };
}
