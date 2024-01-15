{
  config,
  lib,
  pkgs,
  username,
  ...
}: let
  cfg = config.apps.valent;
in
  with lib; {
    options.apps.valent = {
      enable = mkEnableOption ''
        KDEConnect
      '';
    };

    config = mkIf cfg.enable {
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
    };
  }
