{ ... }:

{
  xdg.configFile."spotify-player/app.toml".text = ''
    client_id = "9fe4fbbcf6204173a91b03be52848142"
  '';
  xdg.configFile."spotify-player/keymap.toml".text = ''
    [[keymaps]]
    command = "ResumePause"
    key_sequence = "q"
  '';
}
