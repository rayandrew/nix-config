{ lib, config, ... }:

{
  brewCaskPresent = cask: lib.any (x: x.name == cask) config.homebrew.casks;
}
