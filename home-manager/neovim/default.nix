{ flake
, config
, pkgs
, lib
, ...
}:

# some configurations are taken from 
# https://github.com/NvChad/NvChad

let
  inherit (lib) concatStringsSep optional;
  inherit (config.lib.file) mkOutOfStoreSymlink;

  cfg = config.programs.neovim;

  home = config.home.homeDirectory;
  populateEnv = ./populate-nvim-env.py;

  populateEnvScript = openapi_path: ''
    mkdir -p ${config.xdg.dataHome}/nvim/site/plugin
    ${pkgs.python39}/bin/python ${populateEnv} -o ${config.xdg.dataHome}/nvim/site/plugin --openapi_path "${openapi_path}"
  '';
in
{
  # Neovim

  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.neovim.enable
  programs.neovim = {
    enable = true;
    viAlias = false;
    vimAlias = false;
    defaultEditor = true;
  };

  # xdg.configFile."nvim" = {
  #   source = config.lib.file.mkOutOfStoreSymlink "${home}/.config/nvim";
  #   recursive = true;
  # };

  home.packages = with pkgs.unstable; [
    lua-language-server
    stylua
    shfmt

    # python
    python311Packages.flake8
    python311Packages.black
    python311Packages.python-lsp-server

    # web stuff
    nodePackages_latest.prettier
    nodePackages_latest.eslint_d
    nodePackages_latest.vscode-langservers-extracted
    nodePackages_latest.typescript-language-server

    # rust
    rust-analyzer
    rustfmt

    # config
    taplo

    # nix
    nixpkgs-fmt
    rnix-lsp

    (pkgs.writeShellScriptBin "update-nvim-env" ''
      #
      # update-nvim-env
      #
      # Update neovim env such that it can be used in neovide or other GUIs.
    
      ${populateEnvScript config.sops.secrets.openapi-key.path}
    '')
    (pkgs.writeShellScriptBin "clean-nvim-all" ''
      rm -rf ${config.xdg.dataHome}/nvim
      rm -rf ${config.xdg.cacheHome}/nvim
      rm -rf ${config.xdg.stateHome}/nvim
      rm -rf ${config.xdg.configHome}/nvim
    '')
    (pkgs.writeShellScriptBin "clean-nvim" ''
      rm -rf ${config.xdg.dataHome}/nvim
      rm -rf ${config.xdg.stateHome}/nvim
      rm -rf ${config.xdg.cacheHome}/nvim
    '')
  ];

  home.activation.neovim = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    echo "Populating neovim env..."
    ${populateEnvScript config.sops.secrets.openapi-key.path}
  '';

  programs.zsh.initExtra = lib.mkIf cfg.enable (lib.mkAfter ''
    alias n="${pkgs.neovim}/bin/nvim"
  '');


  sops = {
    age.keyFile = "${home}/.config/sops/age/keys.txt";
    age.generateKey = true;
    secrets = {
      openapi-key = {
        # owner = "rayandrew";
        mode = "0440";
        sopsFile = ../../secrets.yaml;
        # path = "%r/openapi-key.txt";
        path = "${config.home.homeDirectory}/.openai_api_key";
        # neededForUsers = true;
      };
    };
  };
}
# vim: foldmethod=marker
