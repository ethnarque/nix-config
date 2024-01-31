{ config, lib, pkgs, system, username, ... }:
let
  inherit (lib)
    isDarwin
    isLinux
    optionalAttrs
    mkEnableOption
    mkIf
    mkMerge;

  cfg = config.apps.obinskit;
in
{
  options.apps.obinskit = {
    enable = mkEnableOption ''
      obinskit for managing devices like the AnnePro2
    '';
  };

  config = mkIf cfg.enable (mkMerge [
    (optionalAttrs (isLinux system) {
      environment.systemPackages = with pkgs; [
        obinskit # FIXME: Needs to override the desktop entry to add 2x ico. + run with sudo
      ];

      nixpkgs.config.permittedInsecurePackages = [
        "electron-13.6.9"
      ];
    })

    (optionalAttrs (isDarwin system) {
      # TODO: Needs to add obinskit to homebrew
    })
  ]);
}
