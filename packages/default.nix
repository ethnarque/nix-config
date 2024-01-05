{ pkgs ? import <nixpkgs> { } }: {
  dark-mode-notify = pkgs.callPackage ./dark-mode-notify.nix { };
  apple-fonts = pkgs.callPackage ./apple-fonts.nix { };
}
