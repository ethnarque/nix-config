{ config, lib, pkgs, system, username, ... }:
let
  inherit (lib)
    isDarwin
    isLinux
    optionalAttrs
    mkEnableOption
    mkIf
    mkMerge;

  cfg = config.services'.tailscale;
in
{
  options.services'.tailscale = {
    enable = mkEnableOption ''
      tailscale
    '';
  };

  config = mkIf cfg.enable (mkMerge [
    { services.tailscale.enable = true; }

    (optionalAttrs (isLinux system) {
      networking.firewall = {
        checkReversePath = "loose";
        trustedInterfaces = [ "tailscale0" ];
        allowedUDPPorts = [ config.services.tailscale.port ];
      };
    })
  ]);
}
