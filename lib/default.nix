{ lib, config, ... }:

import ./attrsets.nix { inherit lib; } // import ./modules.nix { inherit lib; }
  // import ./brew.nix { inherit lib config; }
