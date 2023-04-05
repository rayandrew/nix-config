{ pkgs, runCommand, ... }:

let bin = ./bin;

in runCommand "scripts"
{
  buildInputs = with pkgs; [ gawk ];
} ''
  mkdir -p $out/bin
  cp ${bin}/* $out/bin
  
  chmod +x $out/bin/*

  for file in $out/bin/*; do
    patchShebangs --build $file
  done
''
