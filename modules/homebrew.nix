{ config, lib, pkgs, system, username, ... }:
with lib;
let
  cfg = config.apps.homebrew;
in
{
  options.apps.homebrew = {
    enable = mkEnableOption "darwin systems defaults";

    taps = mkOption {
      type = with types; listOf str;
      default = [ ];
    };

    caskArgs = mkOption {
      type = types.attrs;
      default = { };
    };

    brews = mkOption {
      type = with types; listOf str;
      default = [ ];
    };

    casks = mkOption {
      type = with types; listOf str;
    };
  };

  config = mkIf cfg.enable (mkMerge [
    (if (builtins.elem system [ "aarch64-darwin" "x86-64-darwin" ]) then
      {
        homebrew = {
          enable = true;
          onActivation.cleanup = "zap";
          taps = cfg.taps ++ [
            "homebrew/homebrew-core"
            "homebrew/homebrew-cask"
            "homebrew/homebrew-bundle"
            "homebrew/cask-fonts"
            "koekeishiya/homebrew-formulae"
            "FelixKratz/homebrew-formulae"
          ];
          brews = cfg.brews ++ [
            "sketchybar"
            "zsh-completions"
            "koekeishiya/formulae/yabai"
            "koekeishiya/formulae/skhd"
          ];
          casks = cfg.casks ++ [
            "alfred"
            "bitwarden"
            "font-symbols-only-nerd-font"
            "font-sf-pro"
            "monitorcontrol"
            "mos"
            "the-unarchiver"
            "utm"
          ];
        };
      }
    else { })
  ]);
}
