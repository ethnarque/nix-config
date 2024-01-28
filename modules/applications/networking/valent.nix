{ config, lib, pkgs, username, system, ... }:

with lib;

let
  cfg = config.apps.valent;
in
{
  options.apps.valent = {
    enable = mkEnableOption ''
      KDEConnect with valent
    '';
  };

  config = mkIf cfg.enable (mkMerge [
    (if !(builtins.elem system [ "aarch64-darwin" "x86_64-darwin" ]) then
      {
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
      }
    else
      { }
    )
  ]);
}
