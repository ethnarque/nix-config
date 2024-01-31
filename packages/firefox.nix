{ fetchurl, stdenv, undmg }:
stdenv.mkDerivation rec {
  pname = "Firefox";
  version = "20.0.1";
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
    sha256 = "N4CUNmt7QNj0vViQ6+4NG09Ejvrh0epDr0Lo4iRPYtg=";
  };
}

