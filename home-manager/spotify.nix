{ ... }:

{
  xdg.configFile."spotify-player/app.toml".text = ''
    client_id = "9fe4fbbcf6204173a91b03be52848142"

    [device]
    name = "spotify-player"
    device_type = "speaker"
    volume = 75
    bitrate = 160
    audio_cache = false
  '';
  xdg.configFile."spotify-player/keymap.toml".text = ''
    [[keymaps]]
    command = "PreviousPage"
    key_sequence = "q"
  '';
}
