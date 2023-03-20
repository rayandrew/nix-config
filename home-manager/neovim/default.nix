{ flake, config, pkgs, lib, ... }:

# some configurations are taken from 
# https://github.com/NvChad/NvChad

let
  inherit (lib) concatStringsSep optional;
  inherit (config.lib.file) mkOutOfStoreSymlink;
  inherit (flake.inputs.nixvim.lib.${pkgs.system}) helpers;

  home = config.home.homeDirectory;
  populateEnv = ./populate-nvim-env.py;

  populateEnvScript = ''
    mkdir -p ${config.xdg.dataHome}/nvim/site/plugin
    ${pkgs.python39}/bin/python ${populateEnv} -o ${config.xdg.dataHome}/nvim/site/plugin
  '';

  # https://pablo.tools/blog/computers/nix-mustache-templates/
  parseTemplate = name: src: data:
    pkgs.stdenv.mkDerivation {
      inherit src;

      name = "${name}";
      nativeBuildInpts = [ pkgs.mustache-go pkgs.findutils ];

      # Pass Json as file to avoid escaping
      passAsFile = [ "jsonData" ];
      jsonData = builtins.toJSON data;

      # Disable phases which are not needed. In particular the unpackPhase will
      # fail, if no src attribute is set
      phases = [ "buildPhase" "installPhase" ];

      buildPhase = ''
        mkdir -p $out
      	for file in $(find $src -type f -print); do
	  stripped_path=''${file#"$src/"}
	  dir_path=$(dirname $stripped_path)
	  filename=$(basename $file)
	  if [[ $dir_path == "." ]]; then
	    dir_path=""
	  else
	    mkdir -p $out/$dir_path
	  fi
	  ${pkgs.mustache-go}/bin/mustache $jsonDataPath $file > "$out/$dir_path/$filename"
	  # cp $file "$out/$dir_path"
	done
      '';

      installPhase = ''

      '';
    };
in
{
  # Neovim

  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.neovim.enable
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;
    # extraLuaConfig = builtins.readFile (parseTemplate "nvim-config" ./config {
    #   plugins = with pkgs; {
    #     lazy = vimPlugins.lazy-nvim;
    #     gruvbox = vimPlugins.gruvbox-nvim;
    #     plenary = vimPlugins.plenary-nvim;
    #     telescope = vimPlugins.telescope-nvim;
    #   };
    # });
  };

  xdg.configFile."nvim" = {
    source = parseTemplate "nvim-config" ./config {
      plugins = with pkgs; {
        lazy = vimPlugins.lazy-nvim;
        gruvbox = vimPlugins.gruvbox-nvim;
        plenary = vimPlugins.plenary-nvim;
        telescope = vimPlugins.telescope-nvim;
      };
    };
    recursive = false;
  };

  home.packages = with pkgs; [
    #   (pkgs.writeShellScriptBin "update-nvim-env" ''
    #     #
    #     # update-nvim-env
    #     #
    #     # Update neovim env such that it can be used in neovide or other GUIs.
    #
    #     ${populateEnvScript}
    #   '')
    (pkgs.writeShellScriptBin "clean-nvim" ''
      rm -rf ${config.xdg.dataHome}/nvim
      rm -rf ${config.xdg.configHome}/nvim
      rm -rf ${config.xdg.cacheHome}/nvim
    '')
  ];

  # home.activation.neovim = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
  #   echo "Populating neovim env..."
  #   ${populateEnvScript}
  # '';
}
# vim: foldmethod=marker
