{ fetchurl, stdenv, undmg }:
stdenv.mkDerivation rec {
  pname = "Firefox";
  version = "122.0";
  buildInputs = [ undmg ];
  sourceRoot = ".";
  phases = [ "unpackPhase" "installPhase" ];
  installPhase = ''
    mkdir -p "$out/Applications"
    cp -r Firefox.app "$out/Applications/Firefox.app"
  '';

  src = fetchurl {
    name = "Firefox-${version}.dmg";
    url = "https://download-installer.cdn.mozilla.net/pub/firefox/releases/${version}/mac/en-GB/Firefox%20${version}.dmg";
    sha256 = "JGZU5HQaqtTVr0lt+ot2b4Lygy19Zw2kwJzitBsSQJY=";
  };
}

