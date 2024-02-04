{ config, lib, pkgs, system, username, ... }:

let
  inherit (lib)
    isLinux
    mkEnableOption
    mkIf
    mkMerge
    optionalAttrs;

  cfg = config.machine.hardware.intel;
in
{
  options.machine.hardware.intel = {
    enable = mkEnableOption ''
      intel defaults
    '';

  };

  config = mkIf cfg.enable (mkMerge [
    (optionalAttrs (isLinux system) {
      nixpkgs.config.packageOverrides = pkgs: {
        vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };

        hardware.opengl = { enable = true; };

        environment.systemPackages = with pkgs; [
          libva-utils
        ];
      };
    })
  ]);
}
