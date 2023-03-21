{ pkgs
, config
, ...
}:

let
  scripts = ./scripts;
  zoxide = "${config.programs.zoxide.package}/bin/zoxide";
  lf = "${config.programs.lf.package}/bin/lf";
  fzf = "${config.programs.fzf.package}/bin/fzf";
  find = "${pkgs.findutils}/bin/find";
  sed = "${pkgs.gnused}/bin/sed";
  rg = "${pkgs.ripgrep}/bin/rg";
in
{
  programs.lf = {
    enable = true;
    settings = {
      color256 = true;
      icons = true;
      preview = true;
    };
    keybindings = {
      "." = "set hidden!";
      f = "$vi $(${fzf})";
      "<c-f>" = ":fzf_jump";
      gs = ":fzf_search";
      # f = "push :fzf<space>";
    };
    commands = {
      # fzf = ''$vi $(find . -name "$1" | ${fzf})'';
      fzf_jump = ''
        ''${{
            res="$(${find} . -maxdepth 1 | ${fzf} --reverse --header='Jump to location' | ${sed} 's/\\/\\\\/g;s/"/\\"/g')"
            if [ -d "$res" ] ; then
                cmd="cd"
            elif [ -f "$res" ] ; then
                cmd="select"
            else
                exit 0
            fi
            ${lf} -remote "send $id $cmd \"$res\""
        }}
      '';
      fzf_search = ''
        ''${{
          res="$( \
               RG_PREFIX="${rg} --column --line-number --no-heading --color=always \
               --smart-case "
               FZF_DEFAULT_COMMAND="$RG_PREFIX '''" \
               ${fzf} --bind "change:reload:$RG_PREFIX {q} || true" \
               --ansi --layout=reverse --header 'Search in files' \
               | cut -d':' -f1
          )"
          [ ! -z "$res" ] && ${lf} -remote "send $id select \"$res\""
        }}
      '';
      z = ''
        %{{
        	${zoxide} result="$( query --exclude $PWD $@)"
        	${lf} -remote "send $id cd $result"
        }}
      '';
      zi = ''
        ''${{
        	result="$(${zoxide} query -i)"
        	${lf} -remote "send $id cd $result"
        }}
      '';
    };

    extraConfig = ''
      # set drawbox # enable border
      set previewer ${scripts}/previewer.sh
      set cleaner ${scripts}/cleaner.sh
      # set colors ${scripts}/colors
      # set icons ${scripts}/icons
    '';
  };

  xdg.configFile."lf/colors".source = ./scripts/colors;
  xdg.configFile."lf/icons".source = ./scripts/icons;

  home.packages = with pkgs; [
    pistol
  ];
}
