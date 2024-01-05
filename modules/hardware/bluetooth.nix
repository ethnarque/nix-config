{ config, lib, pkgs, system, username, ... }:
with lib;
let
  cfg = config.modules.hardware.bluetooth;
in
{
  options.modules.hardware.bluetooth = {
    enable = mkEnableOption "hardware bluetooth";
  };


  config = mkIf cfg.enable (mkMerge [
    (if !(builtins.elem system [ "aarch64-darwin" "x86_64-darwin" ]) then
      {
        hardware.bluetooth.enable = true;
        hardware.bluetooth.powerOnBoot = true;
      }
    else
      { })
  ]);
}
