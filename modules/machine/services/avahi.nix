{ config, lib, pkgs, system, username, ... }:

let
  inherit (lib)
    isLinux
    mkEnableOption
    mkIf
    mkMerge
    optionalAttrs;

  cfg = config.machine.services.avahi;
in
{
  options.machine.services.avahi = {
    enable = mkEnableOption "ssh services";
  };

  config = mkIf cfg.enable (mkMerge [
    (optionalAttrs (isLinux system) {
      services.avahi = {
        enable = true;
        nssmdns = true;
        publish = {
          enable = true;
          addresses = true;
          domain = true;
          hinfo = true;
          userServices = true;
          workstation = true;
        };
      };
    })
  ]);
}
