{ config, inputs, lib, pkgs, system, username, ... }:

let
  inherit (lib)
    isLinux
    mkIf
    mkEnableOption
    optionalAttrs;

  inherit (pkgs) emacs-pgtk fetchpatch;

  cfg = config.apps.emacs;

  emacsDarwinPkg = emacs-pgtk.overrideAttrs (old: {
    patches = (old.patches or [ ])
      ++ [
      # Fix OS window role (needed for window managers like yabai)
      (fetchpatch {
        url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/master/patches/emacs-28/fix-window-role.patch";
        sha256 = "sha256-+z/KfsBm1lvZTZNiMbxzXQGRTjkCFO4QPlEK35upjsE=";
      })
      # Enable rounded window with no decoration
      (fetchpatch {
        url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/master/patches/emacs-30/round-undecorated-frame.patch";
        sha256 = "sha256-uYIxNTyfbprx5mCqMNFVrBcLeo+8e21qmBE3lpcnd+4=";
      })
      # Use poll instead of select to get file descriptors
      (fetchpatch {
        url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/master/patches/emacs-29/poll.patch";
        sha256 = "sha256-jN9MlD8/ZrnLuP2/HUXXEVVd6A+aRZNYFdZF8ReJGfY=";
      })
      # Make Emacs aware of OS-level light/dark mode
      (fetchpatch {
        url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/master/patches/emacs-30/system-appearance.patch";
        sha256 = "sha256-3QLq91AQ6E921/W9nfDjdOUWR8YVsqBAT/W9c1woqAw=";
      })
    ];
  });

  emacsLinuxPkg = emacs-pgtk;

  emacsPkg = if (isLinux system) then emacsLinuxPkg else emacsDarwinPkg;
in
{
  options.apps.emacs = {
    enable = mkEnableOption "emacs";
  };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [
      inputs.emacs-overlay.overlay
    ];

    hm.home.packages = [
      ((pkgs.emacsPackagesFor emacsPkg).emacsWithPackages (epkgs: with epkgs; [
        vterm
        treesit-grammars.with-all-grammars
      ]))
    ];
  };
}
