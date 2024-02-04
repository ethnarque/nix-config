{ config, lib, pkgs, system, username, ... }:

let
  inherit (lib)
    isLinux
    mkEnableOption
    mkIf
    mkMerge
    optionalAttrs;

  cfg = config.machine.hardware.bluetooth;
in
{
  options.machine.hardware.bluetooth = {
    enable = mkEnableOption ''
      hardware bluetooth
    '';
  };

  config = mkIf cfg.enable (mkMerge [
    (optionalAttrs (isLinux system) {
      hardware.bluetooth.enable = true;
      hardware.bluetooth.powerOnBoot = true;
    })
  ]);
}
