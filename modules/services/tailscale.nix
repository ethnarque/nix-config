{ config, lib, pkgs, username, system, ... }:

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

  config = mkIf cfg.enable (mkMerge [
    (if !(builtins.elem system [ "aarch64-darwin" "x86_64-darwin" ]) then
      {
        services.tailscale.enable = true;
        networking.firewall = {
          checkReversePath = "loose";
          trustedInterfaces = [ "tailscale0" ];
          allowedUDPPorts = [ config.services.tailscale.port ];
        };
      }
    else
      { }
    )
  ]);
}
