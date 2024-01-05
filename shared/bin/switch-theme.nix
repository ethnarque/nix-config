{ pkgs }:
let
  dark-theme = pkgs.callPackage ../home-manager/kitty/rose-pine.nix { };
  light-theme = pkgs.callPackage ../home-manager/kitty/rose-pine-dawn.nix { };

  condition =
    if pkgs.stdenv.isDarwin then
      "defaults read -g AppleInterfaceStyle 2>/dev/null"
    else
      "";
in

pkgs.writeScriptBin "switch-theme" ''
  #!${pkgs.stdenv.shell}

  theme=""

  if [[ $(${condition}) ]]; then
    theme="${dark-theme}"
  else
    theme="${light-theme}"
  fi

  ${pkgs.kitty}/bin/kitty @ --to=unix:/tmp/kitty set-colors -a -c $theme
''
