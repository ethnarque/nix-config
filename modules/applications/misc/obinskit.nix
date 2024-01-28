{ config
, lib
, pkgs
, system
, username
, ...
}:
let
  cfg = config.apps.obinskit;
in
{
  options.apps.obinskit = {
    enable = lib.mkEnableOption ''
      obinskit for managing devices like the AnnePro2
    '';
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    (
      if !(builtins.elem system [ "aarch64-darwin" "x86_64-darwin" ])
      then {
        environment.systemPackages = with pkgs; [
          obinskit # FIXME: Needs to override the desktop entry to add 2x ico. + run with sudo
        ];

        nixpkgs.config.permittedInsecurePackages = [
          "electron-13.6.9"
        ];
      }
      else { }
    )
  ]);
}
