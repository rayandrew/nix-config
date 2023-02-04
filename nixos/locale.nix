{
  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = lib.mkDefault "en_US.UTF-8";
    extraLocaleSettings = {
      LC_CTYPE = lib.mkDefault "en_US.UTF-8";
      LC_TIME = lib.mkDefault "en_US.UTF-8";
      LC_ADDRESS = lib.mkDefault "en_US.UTF-8";
      LC_IDENTIFICATION = lib.mkDefault "en_US.UTF-8";
      LC_MEASUREMENT = lib.mkDefault "en_US.UTF-8";
      LC_MONETARY = lib.mkDefault "en_US.UTF-8";
      LC_NAME = lib.mkDefault "en_US.UTF-8";
      LC_NUMERIC = lib.mkDefault "en_US.UTF-8";
      LC_PAPER = lib.mkDefault "en_US.UTF-8";
      LC_TELEPHONE = lib.mkDefault "en_US.UTF-8";
      LC_TIME = lib.mkDefault "en_US.UTF-8";
    };
  };

  # Set X11 keyboard layout.
  services.xserver = {
    layout = lib.mkDefault "us";
    xkbVariant = lib.mkDefault "intl";
    # Remap Caps Lock to Esc, and use Super+Space to change layouts
    xkbOptions = lib.mkDefault "caps:escape,grp:win_space_toggle";
  };
}
