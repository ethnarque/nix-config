{
  config,
  lib,
  pkgs,
  system,
  username,
  ...
}: let
  cfg = config.compositors.wayland;
in {
  options.compositors.wayland = {
    enable = lib.mkEnableOption "common wm";
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    (
      if !(builtins.elem system ["aarch64-darwin" "x86_64-darwin"])
      then {
        machines.hardware.bluetooth.enable = true;
        machines.hardware.sound.enable = true;

        environment.sessionVariables.NIXOS_OZONE_WL = "1";

        programs.light.enable = true;

        users.users.${username}.extraGroups = ["video"];
      }
      else {}
    )
  ]);
}
