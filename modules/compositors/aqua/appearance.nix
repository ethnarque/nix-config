{ config, lib, pkgs, system, username, ... }:
let
  inherit (lib)
    isDarwin
    mkEnableOption
    mkIf
    mkMerge
    optionalAttrs;

  cfg = config.compositors.aqua.appearance;
in
{
  options.compositors.aqua.appearance = {
    enable = mkEnableOption "darwin systems defaults";
  };

  config = mkIf cfg.enable (mkMerge [
    (optionalAttrs (isDarwin system) { })
  ]);
}
