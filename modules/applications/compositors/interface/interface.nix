{
  config,
  lib,
  options,
  pkgs,
  system,
  username,
  ...
}:
with lib; let
  cfg = config.compositors.interface;
in {
  options.compositors.interface = {
    enable = lib.mkEnableOption ''
      interface capabilities for Wayland and X11 compositors
    '';
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    (
      if !(builtins.elem system ["aarch64-darwin" "x86_64-darwin"])
      then {}
      else {}
    )
  ]);
}
