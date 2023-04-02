{ pkgs
, config
, lib
, ...
}:

# sideberry config from
# https://github.com/SuperBo/Firefox-Arc-Style/blob/left-sidebar/sidebery-data.json

let
  inherit (config.my-meta) username;
  cfg = config.programs.firefox;
  stdenv = pkgs.stdenv;

  buildFirefoxXpiAddon = lib.makeOverridable ({ stdenv ? pkgs.stdenv
                                              , fetchurl ? pkgs.fetchurl
                                              , pname
                                              , version
                                              , addonId
                                              , url
                                              , sha256
                                              , meta
                                              , ...
                                              }:
    stdenv.mkDerivation {
      name = "${pname}-${version}";

      inherit meta;

      src = fetchurl { inherit url sha256; };

      preferLocalBuild = true;
      allowSubstitutes = true;

      buildCommand = ''
        dst="$out/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}"
        mkdir -p "$dst"
        install -v -m644 "$src" "$dst/${addonId}.xpi"
      '';
    });

  mozillaConfigPath =
    if stdenv.isDarwin then "Library/Application Support/Mozilla" else ".mozilla";

  firefoxConfigPath =
    if stdenv.isDarwin then
      "Library/Application Support/Firefox"
    else
      "${mozillaConfigPath}/firefox";

  profilesPath =
    if stdenv.isDarwin then "${firefoxConfigPath}/Profiles" else firefoxConfigPath;

  sidebery-beta = buildFirefoxXpiAddon {
    pname = "sidebery";
    version = "5.0.0b31";
    addonId = "{3c078156-979c-498b-8990-85f7987dd929}";
    url = "https://github.com/mbnuqw/sidebery/releases/download/v5.0.0b31/sidebery-5.0.0b31.xpi";
    sha256 = "sha256-J7N1w7T421c0B/oZJjpJJ4AsL1YpqUYaAkJsY5IhI+Y=";
    meta = with lib;
      {
        homepage = "https://github.com/mbnuqw/sidebery";
        description = "Tabs tree and bookmarks in sidebar with advanced containers configuration.";
        license = licenses.mit;
        platforms = platforms.all;
      };
  };

  zotero = buildFirefoxXpiAddon rec {
    pname = "zotero";
    version = "5.0.107";
    addonId = "zotero-${version}";
    url = "https://download.zotero.org/connector/firefox/release/Zotero_Connector-5.0.107.xpi";
    sha256 = "sha256-RuAhWGvUhkog8SxzKhRwQQwzTQLzBKlHjSsFj9e25e4=";
    meta = with lib;
      {
        homepage = "https://www.zotero.org/download/";
        description = "Zotero: Your personal research assistant";
        license = licenses.gpl3;
        platforms = platforms.all;
      };
  };
in
{
  programs.firefox = {
    enable = true;
    package = pkgs.firefox-beta-bin;

    profiles."${username}" = {
      id = 0;
      name = username;
      search = {
        force = true;
        default = "DuckDuckGo";
        engines = {
          "Nix Packages" = {
            urls = [{
              template = "https://search.nixos.org/packages";
              params = [
                { name = "type"; value = "packages"; }
                { name = "query"; value = "{searchTerms}"; }
              ];
            }];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@np" ];
          };
          "NixOS Wiki" = {
            urls = [{ template = "https://nixos.wiki/index.php?search={searchTerms}"; }];
            iconUpdateURL = "https://nixos.wiki/favicon.png";
            updateInterval = 24 * 60 * 60 * 1000;
            definedAliases = [ "@nw" ];
          };
          "Wikipedia (en)".metaData.alias = "@wiki";
          "Google".metaData.hidden = true;
          "Amazon.com".metaData.hidden = true;
          "Bing".metaData.hidden = true;
          "eBay".metaData.hidden = true;
        };
      };
      settings = {
        "general.smoothScroll" = true;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "browser.toolbars.bookmarks.visibility" = "never";
      };
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        sidebery-beta
        onepassword-password-manager
        zotero
        enhanced-github
        enhancer-for-youtube
        octotree
        darkreader
        privacy-badger
        facebook-container
        forget_me_not
      ];
    };
  };

  home.file = {
    "${profilesPath}/${cfg.profiles."${username}".path}/chrome" = {
      source = ./profiles/rayandrew/chrome;
      recursive = true;
    };
    "${profilesPath}/${cfg.profiles."${username}".path}/sideberry" = {
      source = ./profiles/rayandrew/sideberry;
      recursive = true;
    };
  };
}
