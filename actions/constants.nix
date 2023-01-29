{
  ubuntu.runs-on = "ubuntu-latest";
  macos.runs-on = "macos-latest";
  home-manager = {
    linux.hostnames = [ "home-linux" ];
    darwin.hostnames = [ "home-macos" ];
  };
  nixos.hostnames = [ ];
  nix-darwin.hostnames = [ "github-ci" ];
}
