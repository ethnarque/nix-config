{ config, lib, pkgs, system, username, ... }:
with lib;
let
  cfg = config.modules.hardware.sound;
in
{
  options.modules.hardware.sound = {
    enable = mkEnableOption "hardware sound";
  };

  config = mkIf cfg.enable (mkMerge [
    (if !(builtins.elem system [ "aarch64-darwin" "x86_64-darwin" ]) then
      {
        sound.enable = true;

        services.pipewire = {
          enable = true;
          alsa.enable = true;
          pulse.enable = true;
        };
      }
    else
      { })
  ]);
}
