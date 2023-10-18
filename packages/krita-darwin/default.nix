{ pkgs
, lib
, ...
}:

pkgs.stdenvNoCC.mkDerivation rec {
  pname = "krita";
  version = "5.1.5";

  buildInputs = [ pkgs.undmg ];
  sourceRoot = ".";
  phases = [ "unpackPhase" "installPhase" ];
  installPhase = ''
    mkdir -p $out/Applications
    cp -r Krita*.app "$out/Applications/"
  '';
  unpackCmd = ''
    echo "File to unpack: $curSrc"
    if ! [[ "$curSrc" =~ \.dmg$ ]]; then return 1; fi
    mnt=$(mktemp -d -t ci-XXXXXXXXXX)

    function finish {
      echo "Detaching $mnt"
      /usr/bin/hdiutil detach $mnt -force
      rm -rf $mnt
    }
    trap finish EXIT

    echo "Attaching $mnt"
    # /usr/bin/hdiutil attach -nobrowse -readonly $src -mountpoint $mnt
    /usr/bin/hdiutil attach -nobrowse $src -mountpoint $mnt

    echo "What's in the mount dir"?
    ls -la $mnt/

    # echo "Copying contents"
    # shopt -s extglob
    # DEST="$PWD"
    # # (cd "$mnt"; cp -a !(Applications) "$DEST/")
  '';

  src = pkgs.fetchurl {
    name = "Krita-${version}.dmg";
    url = "https://download.kde.org/stable/krita/${version}/krita-${version}.dmg";
    sha256 = "sha256-Ck50LJEiW4VjSEzrwaVbU1b9An1yKpUfPfeEevEPcv0=";
  };

  meta = {
    description = "A free and open source painting application";
    homepage = "https://krita.org/";
    platforms = lib.platforms.darwin;
  };
}
