{ config, lib, pkgs, system, username, ... }:
with lib;
let
  cfg = config.modules.file-managers;
in
{
  options.modules.file-managers = {
    enable = mkEnableOption "minimal file managers support";
  };
  config = mkIf cfg.enable (mkMerge [
    (if !(builtins.elem system [ "aarch64-darwin" "x86_64-darwin" ]) then
      {
        services.devmon.enable = true;
        services.gvfs.enable = true;
        services.udisks2.enable = true;
      }
    else
      { })
  ]);
}
