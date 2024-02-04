{ config, lib, pkgs, system, username, ... }:
let
  inherit (lib)
    isDarwin
    mkEnableOption
    mkIf
    mkMerge
    optionalAttrs;

  cfg = config.machine.hardware.android;
in
{
  options.machine.hardware.android = {
    enable = mkEnableOption ''
      android 
    '';

  };

  config = mkIf cfg.enable (mkMerge [
    {
      environment.systemPackages = with pkgs;[
        android-tools
      ];
    }

    (optionalAttrs (isDarwin system) {
      homebrew.casks = [
        "android-file-transfer"
      ];
    })
  ]);
}
