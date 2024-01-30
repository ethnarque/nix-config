{ config, lib, pkgs, system, username, ... }:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkMerge;

  cfg = config.compositors.darwin;
in
{
  options.compositors.darwin = {
    enable = mkEnableOption ''
      minimal defaults for compositors and window managers
    '';
  };

  config = mkIf cfg.enable (mkMerge [
    (
      if !(builtins.elem system [ "aarch64-darwin" "x86_64-darwin" ])
      then { }
      else {
        #compositors.appearance.enable = true;

      }
    )
  ]);
}
