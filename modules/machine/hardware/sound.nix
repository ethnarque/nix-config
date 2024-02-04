{ config, lib, pkgs, system, username, ... }:

let
  inherit (lib)
    isLinux
    mkEnableOption
    mkIf
    mkMerge
    optionalAttrs;

  cfg = config.machine.hardware.sound;
in
{
  options.machine.hardware.sound = {
    enable = mkEnableOption ''
      hardware sound
    '';
  };

  config = mkIf cfg.enable (mkMerge [
    (optionalAttrs (isLinux system) {
      sound.enable = true;

      services.pipewire = {
        enable = true;
        alsa.enable = true;
        pulse.enable = true;
      };
    })
  ]);
}
