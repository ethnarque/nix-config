{ config, lib, pkgs, username, ... }:
with lib;
let
  cfg = config.services'.tailscale;
in
{
  options.services'.tailscale = {
    enable = mkEnableOption ''
      tailscale
    '';
  };

  config = mkIf cfg.enable {
    services.tailscale.enable = true;
    networking.firewall = {
      checkReversePath = "loose";
      trustedInterfaces = [ "tailscale0" ];
      allowedUDPPorts = [ config.services.tailscale.port ];
    };
  };
}
