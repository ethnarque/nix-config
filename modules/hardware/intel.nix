{ config, lib, pkgs, system, username, ... }:
with lib;
let
  cfg = config.machines.linux.hardware.intel;
in
{
  options.machines.linux.hardware.intel = {
    enable = mkEnableOption "intel sane defaults";
  };
  config = mkIf cfg.enable (mkMerge [
    (if !(builtins.elem system [ "aarch64-darwin" "x86_64-darwin" ]) then
      {
        nixpkgs.config.packageOverrides = pkgs: {
          vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
        };

        hardware.opengl = {
          enable = true;
        };

        environment.systemPackages = with pkgs; [
          libva-utils
        ];
      }
    else
      { })
  ]);
}
