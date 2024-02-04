{ config, lib, pkgs, system, username, ... }:

let
  inherit (lib)
    isLinux
    mkEnableOption
    mkIf
    mkMerge
    optionalAttrs;

  cfg = config.machine.services.printing;
in
{
  options.machine.services.printing = {
    enable = mkEnableOption ''
      Printing services (CUPS)
    '';

  };

  config = mkIf cfg.enable (mkMerge [
    (optionalAttrs (isLinux system) {
      services.printing.enable = true;
    })
  ]);
}
