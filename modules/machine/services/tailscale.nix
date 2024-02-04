{ config, lib, pkgs, system, username, ... }:
let
  inherit (lib)
    isDarwin
    isLinux
    mkEnableOption
    mkIf
    mkMerge
    optionalAttrs;

  cfg = config.machine.services.tailscale;
in
{
  options.machine.services.tailscale = {
    enable = mkEnableOption ''
      tailscale
    '';

  };

  config = mkIf cfg.enable (mkMerge [
    (optionalAttrs (isDarwin system) {
      homebrew.casks = [
        "tailscale"
      ];

      hm.programs.zsh.shellAliases = {
        tailscale = "/Applications/Tailscale.app/Contents/MacOS/Tailscale";
      };
    })

    (optionalAttrs (isLinux system) {
      services.tailscale.enable = true;

      networking.firewall = {
        checkReversePath = "loose";
        trustedInterfaces = [ "tailscale0" ];
        allowedUDPPorts = [ config.services.tailscale.port ];
      };
    })
  ]);
}
