{ pkgs, stdenv, writeScriptBin }:
let
  dark-theme = pkgs.callPackage ../rose-pine.nix { };
  light-theme = pkgs.callPackage ../rose-pine-dawn.nix { };

  condition =
    if stdenv.isDarwin then
      "defaults read -g AppleInterfaceStyle 2>/dev/null"
    else
      "";


in
writeScriptBin "kitty-auto-appearance" ''
  #!${stdenv.shell}

  theme=""

  if [[ $(${condition}) ]]; then
    theme=${dark-theme}
  else
    theme=${light-theme}
  fi

  ${pkgs.kitty}/bin/kitty @ --to=unix:/tmp/kitty set-colors -a -c $theme
''
