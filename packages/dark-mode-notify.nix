{ lib, stdenv, fetchFromGitHub, swift, swiftpm, swiftPackages, darwin }:
stdenv.mkDerivation {
  name = "dark-mode-notify";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "pmlogist";
    repo = "dark-mode-notify";
    rev = "4d7fe211f81c5b67402fad4bed44995344a260d1";
    sha256 = "LsAQ5v5jgJw7KsJnQ3Mh6+LNj1EMHICMoD5WzF3hRmU=";
  };

  nativeBuildInputs = [
    swift
    swiftpm
    swiftPackages.Foundation
    darwin.apple_sdk.frameworks.Cocoa
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp ./.build/release/dark-mode-notify $out/bin
  '';
}
