{
  config,
  lib,
  pkgs,
  system,
  username,
  ...
}: let
  cfg = config.compositors.minimal;
in {
  options.compositors.minimal = {
    enable = lib.mkEnableOption ''
      minimal defaults for compositors and window managers
    '';
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    (
      if !(builtins.elem system ["aarch64-darwin" "x86_64-darwin"])
      then {
        machines.hardware.bluetooth.enable = true;
        machines.hardware.sound.enable = true;

        appearance.gtk.enable = true;

        environment.sessionVariables.NIXOS_OZONE_WL = "1";
      }
      else {}
    )
  ]);
}
