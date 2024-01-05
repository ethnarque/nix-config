{ config, lib, options, pkgs, system, username, ... }:
let
  cfg = config.modules.fonts;
in
{
  options.modules.fonts = {
    enable = lib.mkEnableOption "kitty terminal";

    packages = lib.mkOption {
      type = with lib.types; listOf path;
      default = [ ];
      example = lib.literalExpression "[ pkgs.dejavu_fonts ]";
      description = lib.mdDoc "List of primary font packages.";
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    (if !(builtins.elem system [ "aarch64-darwin" "x86_64-darwin" ]) then
      {
        fonts = {
          fontconfig.enable = true;
          fontDir.enable = true;
          packages = with pkgs; cfg.packages ++ [
            (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
          ];
        };
      }
    else
      {
        fonts.fonts = with pkgs; cfg.packages ++ [
          (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
        ];
      })
  ]);
}
