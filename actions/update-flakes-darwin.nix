let
  steps = import ./steps.nix;
  constants = import ./constants.nix;
in
with constants; {
  name = "update-flakes-darwin";
  on = {
    workflow_run = {
      workflows = [ "update-flakes" ];
      types = [ "completed" ];
    };
    workflow_dispatch = null;
  };
  jobs = {
    update-flakes-macos = {
      inherit (macos) runs-on;
      "if" = "\${{ github.event.workflow_run.conclusion == 'success' }}";
      steps = with steps; [
        cancelPreviousRuns
        checkoutStep
        (installNixActionStep { channel = "nixpkgs-unstable"; })
        cachixActionStep
        setDefaultGitBranchStep
        (buildHomeManagerConfigurations home-manager.darwin.hostnames)
        (buildNixDarwinConfigurations nix-darwin.hostnames)
      ];
    };
  };
}
