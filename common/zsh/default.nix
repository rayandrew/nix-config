{ config, lib, pkgs, ... }:

let
  inherit (lib) elem optionalString;
  inherit (config.my) shellAliases directory;
  scripts = ./scripts;
in
{
  # Fish Shell
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.fish.enable
  home.packages = with pkgs; [
    zsh-vi-mode
  ];
  programs.zsh = {
    enable = true;
    shellAliases = shellAliases;
    defaultKeymap = "viins";
    zplug = {
      enable = true;
      plugins = [
        { name = "zsh-users/zsh-autosuggestions"; }
        { name = "zsh-users/zsh-syntax-highlighting"; }
        { name = "hlissner/zsh-autopair"; }
        { name = "marlonrichert/zsh-edit"; }
        { name = "jeffreytse/zsh-vi-mode"; }
        { name = "plugins/git"; tags = [ from:oh-my-zsh ]; }
      ];
    };

    # enableCompletion = false;
    # defaultKeymap = "vicmd";
    # enableAutosuggestions = true;
    # enableSyntaxHighlighting = true;
    # autocd = true;
    # plugins = with pkgs; [
    #   {
    #     name = "zsh-syntax-highlighting";
    #     src = fetchFromGitHub {
    #       owner = "zsh-users";
    #       repo = "zsh-syntax-highlighting";
    #       rev = "b2c910a85ed84cb7e5108e7cb3406a2e825a858f";
    #       sha256 = "1b4hqdsfvcg87wm8jpvrh1005nzij2wgl0wbcrvgkcjqmxb2874p";
    #     };
    #     file = "zsh-syntax-highlighting.zsh";
    #   }
    #   {
    #     name = "zsh-autopair";
    #     src = fetchFromGitHub {
    #       owner = "hlissner";
    #       repo = "zsh-autopair";
    #       rev = "396c38a7468458ba29011f2ad4112e4fd35f78e6";
    #       sha256 = "0q9wg8jlhlz2xn08rdml6fljglqd1a2gbdp063c8b8ay24zz2w9x";
    #     };
    #     file = "autopair.zsh";
    #   }
    #   {
    #     name = "zsh-edit";
    #     src = fetchFromGitHub {
    #       owner = "marlonrichert";
    #       repo = "zsh-edit";
    #       rev = "4a8fa599792b6d52eadbb3921880a40872013d28";
    #       sha256 = "09gjb0c9ilnlc14ihpm93v6f7nz38fbn856djn3lj5vz62zjg3iw";
    #     };
    #     file = "zsh-edit.plugin.zsh";
    #   }
    #   {
    #     name = "zsh-autosuggestions";
    #     src = fetchFromGitHub {
    #       owner = "zsh-users";
    #       repo = "zsh-autosuggestions";
    #       rev = "a411ef3e0992d4839f0732ebeb9823024afaaaa8";
    #       sha256 = "1g3pij5qn2j7v7jjac2a63lxd97mcsgw6xq6k5p7835q9fjiid98";
    #     };
    #     file = "zsh-autosuggestions.zsh";
    #   }
    #   {
    #     name = "zsh-vi-mode";
    #     src = fetchFromGitHub {
    #       owner = "jeffreytse";
    #       repo = "zsh-vi-mode";
    #       rev = "0e666689b6b636fee6a80564fd6c4cb02b8b590d";
    #       sha256 = "1cxy3qzm25azr31sggq01yf5l13i8z5x118pl6vmlbl6bkww5fcn";
    #     };
    #     file = "zsh-vi-mode.zsh";
    #   }
    # ];

    # oh-my-zsh = {
    #   enable = true;
    #   plugins = [
    #     "asdf"
    #     "aliases"
    #     "bundler"
    #     "dotenv"
    #     "git"
    #     "macos"
    #     "rake"
    #     "rbenv"
    #     "ruby"
    #     "z"
    #   ];
    # };

    initExtraFirst = ''
      eval "$(${pkgs.starship}/bin/starship init zsh)"
    '';

    initExtra = ''

      # source "${scripts}/p10k.zsh"
      # export ZVM_CURSOR_STYLE_ENABLED=false
      # source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
    '';
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
}
# vim: foldmethod=marker
