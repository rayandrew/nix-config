{ flake
, pkgs
, lib
, ...
}:

{
  nixvim = flake.inputs.nixvim.lib.${pkgs.system};
}
