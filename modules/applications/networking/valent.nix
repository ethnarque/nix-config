{ config, lib, pkgs, username, system, ... }:
let
  inherit (lib)
    isLinux
    optionalAttrs
    mkEnableOption
    mkIf
    mkMerge;

  cfg = config.apps.valent;
in
{
  options.apps.valent = {
    enable = mkEnableOption ''
      KDEConnect with valent
    '';
  };

  config = mkIf cfg.enable (mkMerge [
    (optionalAttrs (isLinux system) {

      programs.kdeconnect.enable = true;
      programs.kdeconnect.package = pkgs.valent;

      networking.firewall.enable = true;
      networking.firewall.allowedTCPPortRanges = [
        {
          from = 1714;
          to = 1764;
        }
      ];
      networking.firewall.allowedUDPPortRanges = [
        {
          from = 1714;
          to = 1764;
        }
      ];
    })
  ]);
}
