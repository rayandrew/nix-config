{ config, lib, pkgs, ... }:

with lib;

let
   dirModule = types.submodule {
    options = {
      nix = mkOption {
        type = types.str;
        # default = "${config.home.homeDirectory}/.config/nixpkgs";
        description = "Path to `nixpkgs` directory";
      };

      projects = mkOption {
        type = types.str;
        # default = "${config.home.homeDirectory}/Projects";
        # defaultText = "\${config.home.homeDirectory}/Projects";
        description = "Path to `Projects` directory";
      };
    };
  };
in
{
  options.my = {
    username = mkOption { type = types.str; };
    name = mkOption { type = types.str; };
    email = mkOption { type = types.str; };
    uid = mkOption { type = types.int; };
    keys = mkOption { type = types.listOf types.singleLineStr; };
    directory = mkOption { type = with types; nullOr dirModule; default = null; };
    shellAliases = mkOption {
      default = {};
      example = literalExpression ''
      {
        ll = "ls -l";
        ".." = "cd ..";
      }
      '';
      description = ''
        An attribute set that maps aliases (the top level attribute names in
        this option) to command strings or directly to build outputs.
      '';
      type = types.attrsOf types.str;
    };
  };
  config = {
    my = {
      username = "rayandrew";
      name = "Ray Andrew";
      email = "4437323+rayandrew@users.noreply.github.com";
      uid = 1000;
      keys = [ ];
      directory = {
        nix = "${config.home.homeDirectory}/.config/nixpkgs";
        projects = "${config.home.homeDirectory}/Projects";
      };
      shellAliases = with pkgs; {
        # Nix related
        drb = "darwin-rebuild build --flake ${config.my.directory.nix}";
        drs = "darwin-rebuild switch --flake ${config.my.directory.nix}";
        flakeup = "nix flake update ${config.my.directory.nix}";
        nb = "nix build";
        nd = "nix develop";
        nf = "nix flake";
        nr = "nix run";
        ns = "nix search";
        npu = "nix-prefetch-url --unpack";

        # Other
        ".." = "cd ..";
        ":q" = "exit";
        cat = "${bat}/bin/bat";
        du = "${du-dust}/bin/dust";
        g = "${gitAndTools.git}/bin/git";
        la = "ll -a";
        ll = "ls -l --time-style long-iso --icons";
        ls = "${exa}/bin/exa";
        tb = "toggle-background";
      };
    };
  };
}
