{ config, lib, pkgs, system, username, ... }:
let
  inherit (lib)
    isLinux
    optionalAttrs
    mkEnableOption
    mkIf
    mkMerge;

  cfg = config.modules.file-managers;
in
{
  options.modules.file-managers = {
    enable = mkEnableOption "minimal file managers support";
  };

  config = mkIf cfg.enable (mkMerge [
    (optionalAttrs (isLinux system) {
      services.devmon.enable = true;
      services.gvfs.enable = true;
      services.udisks2.enable = true;
    })
  ]);
}
