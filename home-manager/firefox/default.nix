{ pkgs
, config
, lib
, ...
}:

# sideberry config from
# https://github.com/SuperBo/Firefox-Arc-Style/blob/left-sidebar/sidebery-data.json

let
  inherit (config.my-meta) username;
  buildFirefoxXpiAddon = pkgs.nur.repos.rycee.firefox-addons.buildFirefoxXpiAddon;

  cfg = config.programs.firefox;
  stdenv = pkgs.stdenv;

  mozillaConfigPath =
    if stdenv.isDarwin then "Library/Application Support/Mozilla" else ".mozilla";

  firefoxConfigPath =
    if stdenv.isDarwin then
      "Library/Application Support/Firefox"
    else
      "${mozillaConfigPath}/firefox";

  profilesPath =
    if stdenv.isDarwin then "${firefoxConfigPath}/Profiles" else firefoxConfigPath;
in
{
  programs.firefox = {
    enable = true;
    # package = pkgs.firefox-beta-bin;
    package = pkgs.firefox-devedition-bin;

    profiles."${username}" = {
      id = 0;
      name = username;
      search = {
        force = true;
        default = "Google";
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
          # "Google".metaData.hidden = true;
          "Amazon.com".metaData.hidden = true;
          "Bing".metaData.hidden = true;
          "eBay".metaData.hidden = true;
        };
      };
      settings = {
        "general.smoothScroll" = true;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "browser.toolbars.bookmarks.visibility" = "never";
        "browser.startup.page" = 3;
        "xpinstall.signatures.required" = false;
      };
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        onepassword-password-manager
        enhanced-github
        enhancer-for-youtube
        octotree
        darkreader
        privacy-badger
        facebook-container
        forget_me_not
        # firenvim
        react-devtools
        private-relay
        disable-javascript
        ublock-origin
        (buildFirefoxXpiAddon {
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
        })
        (buildFirefoxXpiAddon rec {
          pname = "zotero";
          version = "5.0.107";
          addonId = "5.0.107@zotero.org";
          url = "https://download.zotero.org/connector/firefox/release/Zotero_Connector-${version}.xpi";
          sha256 = "sha256-RuAhWGvUhkog8SxzKhRwQQwzTQLzBKlHjSsFj9e25e4=";
          meta = with lib;
            {
              homepage = "https://www.zotero.org/download/";
              description = "Zotero: Your personal research assistant";
              license = licenses.gpl3;
              platforms = platforms.all;
            };
        })
        (buildFirefoxXpiAddon rec {
          pname = "omni";
          version = "1.4.5";
          addonId = "1.4.5@omni.org";
          url = "https://addons.mozilla.org/firefox/downloads/file/3925614/omnisearch-1.4.5.xpi";
          sha256 = "sha256-EbHtBE78Kc5IoiBgSZWXAPWcM/XWMQh/yD7+pbLQJpY=";
          meta = with lib; {
            homepage = "https://github.com/alyssaxuu/omni";
            description = "The all-in-one tool to supercharge your productivity";
            license = licenses.gpl3;
            platforms = platforms.all;
          };
        })
        (buildFirefoxXpiAddon {
          pname = "arxiv-utils";
          version = "1.4";
          addonId = "ab779d78-7270-4ee8-9ee8-369d73508298";
          url = "https://addons.mozilla.org/firefox/downloads/file/3398798/arxiv_utils-1.4-an+fx.xpi";
          sha256 = "13nlqbh7bpl3j22rhfbjhdrj055b8slv6xzacy5wi6y165fndn8f";
          meta = { };
        })
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
