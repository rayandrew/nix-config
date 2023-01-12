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

      research = mkOption {
        type = types.str;
        description = "Path to `Research` directory";
      };

      notes = mkOption {
        type = types.str;
        description = "Path to `Notes` directory";
      };
    };
  };
  mainBranch = config.my.mainBranch;
  git = "${pkgs.gitAndTools.git}/bin/git";
in {
  options.my = {
    username = mkOption { type = types.str; };
    name = mkOption { type = types.str; };
    email = mkOption { type = types.str; };
    uid = mkOption { type = types.int; };
    keys = mkOption { type = types.listOf types.singleLineStr; };
    directory = mkOption {
      type = with types; nullOr dirModule;
      default = null;
    };
    mainBranch = mkOption {
      type = types.str;
      default = "main";
    };
    shellAliases = mkOption {
      default = { };
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
      mainBranch = "main";
      keys = [ ];
      directory = {
        nix = "${config.home.homeDirectory}/.config/nixpkgs";
        projects = "${config.home.homeDirectory}/Projects";
        research = "${config.home.homeDirectory}/Research";
        notes = "${config.home.homeDirectory}/Notes";
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

        # Git
        ## Git status alias
        g = "${git} status -sb";
        gst = "${git} status -sb";
        ## Git add and remove aliases
        ga = "${git} add";
        gr = "${git} rm";
        ## Git branch alias
        gb = "${git} branch -v";
        gba =
          "${git} for-each-ref --sort=committerdate refs/heads/ --format=\"%(authordate:short) %(color:red)%(objectname:short) ''%(color:yellow)%(refname:short)%(color:reset) (%(color:green)%(committerdate:relative)%(color:reset))\"";
        gbd = ''
          ${git} for-each-ref --sort=-committerdate refs/heads/ --format="%(authordate:short) %(color:red)%(objectname:short) %(color:yellow)%(refname:short)%(color:reset) (%(color:green)%(committerdate:relative)%(color:reset))"'';
        ## Git commit aliases
        gc = "${git} commit";
        gca = "${git} commit --amend";
        gcm = "${git} commit -m";
        ## Git checkout aliases
        gcheck = "${git} checkout";
        gcod = "${git} checkout develop";
        gcom = "${git} checkout ${mainBranch}";
        gcos = "${git} checkout staging";
        ## Git fetch aliases
        gf = "${git} fetch";
        gfa = "${git} fetch --all";
        ## Git pull alias
        gpl = "${git} pull --rebase";
        ## Git pull from origin aliases
        gprod = "${git} pull --rebase origin develop";
        gprom = "${git} pull --rebase origin ${mainBranch}";
        gpros = "${git} pull --rebase origin staging";
        ## Git pull from upstream aliases
        gprud = "${git} pull --rebase upstream develop";
        gprum = "${git} pull --rebase upstream ${mainBranch}";
        gprus = "${git} pull --rebase upstream staging";
        ## Git push to origin aliases
        gp = "${git} push";
        gpod = "${git} push origin develop";
        gpom = "${git} push origin main";
        gpos = "${git} push origin staging";
        ## Git push to upstream aliases
        gpud = "${git} push upstream develop";
        gpum = "${git} push upstream ${mainBranch}";
        gpus = "${git} push upstream staging";
        ## Git push with the --force-with-lease option
        gpofl = "${git} push --force-with-lease origin";
        gpufl = "${git} push --force-with-lease upstream";
        ## Git rebase aliases
        gra = "${git} rebase --abort";
        grc = "${git} rebase --continue";
        grd = "${git} rebase develop";
        gri = "${git} rebase -i";
        grm = "${git} rebase ${mainBranch}";
        grs = "${git} rebase staging";
        ## Git stash aliases
        gsl = "${git} stash list";
        gsp = "${git} stash pop";
        gss = "${git} stash save";
        ## Git diff and log aliases
        gd = "${git} diff --color-words";
        gl = "${git} log --oneline --decorate";
        gslog = ''
          ${git} log --graph --abbrev-commit --decorate --date=relative --format=format:"%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)" --all'';

        # Other
        ".." = "cd ..";
        ":q" = "exit";
        cat = "${bat}/bin/bat";
        du = "${du-dust}/bin/dust";
        la = "ll -a";
        ll = "ls -l --time-style long-iso --icons";
        ls = "${exa}/bin/exa";
        tb = "toggle-background";
      };
    };
  };
}
