let
  steps = import ./steps.nix;
  constants = import ./constants.nix;
in
with constants; {
  name = "update-flakes";
  on = {
    schedule = [{ cron = "40 4 * * 0,2,4,6"; }];
    workflow_dispatch = null;
  };
  jobs = {
    update-flakes = {
      inherit (ubuntu) runs-on;
      steps = with steps; [
        cancelPreviousRuns
        maximimizeBuildSpaceStep
        checkoutStep
        (installNixActionStep { })
        cachixActionStep
        updateFlakeLockStep
        setDefaultGitBranchStep
        (buildHomeManagerConfigurations home-manager.linux.hostnames)
        (buildNixOSConfigurations nixos.hostnames)
        createPullRequestStep
      ];
    };
  };
}
