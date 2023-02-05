{ lib, config, pkgs, ... }:

with lib;

let cfg = config.my-meta;
in {
  options.my-meta = {
    username = mkOption {
      description = "Main username";
      type = types.str;
      default = "rayandrew";
    };
    name = mkOption {
      description = "Real name";
      type = types.str;
      default = "Ray Andrew";
    };
    email = mkOption {
      type = types.str;
      default = "4437323+rayandrew@users.noreply.github.com";
    };
    uid = mkOption {
      type = types.int;
      default = 1000;
    };
    keys = mkOption {
      type = types.listOf types.singleLineStr;
      default = [ ];
    };
    mainBranch = mkOption {
      type = types.str;
      default = "main";
    };
    systemPath = mkOption {
      type = types.str;
      default = "";
    };
    shellAliases = mkOption {
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
      default = with pkgs; lib.mkMerge [
        (lib.mkIf (pkgs.stdenv.isDarwin) {
          drb = "darwin-rebuild build --flake ${cfg.nixConfigPath}";
          drs = "darwin-rebuild switch --flake ${cfg.nixConfigPath}";
        })

        (lib.mkIf (pkgs.stdenv.isLinux) {
          nrb = "nixos-rebuild build --flake ${cfg.nixConfigPath}";
          nrs = "sudo nixos-rebuild switch --flake ${cfg.nixConfigPath}";
        })

        {
          flakeup = "nix flake update ${cfg.nixConfigPath}";
          nb = "nix build";
          nd = "nix develop";
          nf = "nix flake";
          nr = "nix run";
          ns = "nix search";
          npu = "nix-prefetch-url --unpack";

          # Git
          ## Git status alias
          g = "git status -sb";
          gst = "git status -sb";
          ## Git add and remove aliases
          ga = "git add";
          gr = "git rm";
          ## Git branch alias
          gb = "git branch -v";
          gba =
            "git for-each-ref --sort=committerdate refs/heads/ --format=\"%(authordate:short) %(color:red)%(objectname:short) ''%(color:yellow)%(refname:short)%(color:reset) (%(color:green)%(committerdate:relative)%(color:reset))\"";
          gbd = ''
            git for-each-ref --sort=-committerdate refs/heads/ --format="%(authordate:short) %(color:red)%(objectname:short) %(color:yellow)%(refname:short)%(color:reset) (%(color:green)%(committerdate:relative)%(color:reset))"'';
          ## Git commit aliases
          gc = "git commit";
          gca = "git commit --amend";
          gcm = "git commit -m";
          ## Git checkout aliases
          gcheck = "git checkout";
          gcod = "git checkout develop";
          gcom = "git checkout ${cfg.mainBranch}";
          gcos = "git checkout staging";
          ## Git fetch aliases
          gf = "git fetch";
          gfa = "git fetch --all";
          ## Git pull alias
          gpl = "git pull --rebase";
          ## Git pull from origin aliases
          gprod = "git pull --rebase origin develop";
          gprom = "git pull --rebase origin ${cfg.mainBranch}";
          gpros = "git pull --rebase origin staging";
          ## Git pull from upstream aliases
          gprud = "git pull --rebase upstream develop";
          gprum = "git pull --rebase upstream ${cfg.mainBranch}";
          gprus = "git pull --rebase upstream staging";
          ## Git push to origin aliases
          gp = "git push";
          gpod = "git push origin develop";
          gpom = "git push origin main";
          gpos = "git push origin staging";
          ## Git push to upstream aliases
          gpud = "git push upstream develop";
          gpum = "git push upstream ${cfg.mainBranch}";
          gpus = "git push upstream staging";
          ## Git push with the --force-with-lease option
          gpofl = "git push --force-with-lease origin";
          gpufl = "git push --force-with-lease upstream";
          ## Git rebase aliases
          gra = "git rebase --abort";
          grc = "git rebase --continue";
          grd = "git rebase develop";
          gri = "git rebase -i";
          grm = "git rebase ${cfg.mainBranch}";
          grs = "git rebase staging";
          ## Git stash aliases
          gsl = "git stash list";
          gsp = "git stash pop";
          gss = "git stash save";
          ## Git diff and log aliases
          gd = "git diff --color-words";
          gl = "git log --oneline --decorate";
          gslog = ''
            git log --graph --abbrev-commit --decorate --date=relative --format=format:"%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)" --all'';

          # Other
          ".." = "cd ..";
          ":q" = "exit";
          cat = "${bat}/bin/bat";
          du = "${du-dust}/bin/dust";
          la = "ll -a";
          ll = "ls -l --time-style long-iso --icons";
          ls = "${exa}/bin/exa";
          tb = "toggle-background";
        }
      ];
    };

    # Paths
    nixConfigPath = mkOption {
      type = types.str;
      description = "Path to `nixpkgs` directory";
    };

    projectsDirPath = mkOption {
      type = types.nullOr types.str;
      description = "Path to `Projects` directory";
      default = null;
    };

    researchDirPath = mkOption {
      type = types.nullOr types.str;
      description = "Path to `Research` directory";
      default = null;
    };
  };
}
