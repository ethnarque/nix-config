{ config, lib, pkgs, system, username, ... }:

let
  inherit (lib)
    isLinux
    mkEnableOption
    mkIf
    mkMerge
    mkOption
    optionalAttrs
    types;

  cfg = config.machine.services.ssh;
in
{
  options.machine.services.ssh = {
    enable = mkEnableOption "ssh services";

    matchBlocks = mkOption {
      type = with types; nullOr attrs;
      default = { };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    (optionalAttrs (isLinux system) {
      networking.firewall.allowedTCPPorts = [ 22 ];
      services.openssh.enable = true;
    })

    {
      hm.programs.ssh = {
        enable = true;

        matchBlocks = mkMerge [
          {
            "codeberg.org" = {
              hostname = "codeberg.org";
              identityFile = "~/.ssh/id_ed25519.codeberg";
            };

            "moi.ethnarque.co" = {
              hostname = "moi.ethnarque.co";
              identityFile = "~/.ssh/id_ed25519.hetzner";
            };

            "github.com" = {
              hostname = "github.com";
              identityFile = "~/.ssh/id_ed25519.github";
            };

            "gitlab.com" = {
              hostname = "gitlab.com";
              identityFile = "~/.ssh/id_ed25519.gitlab";
            };
          }

          cfg.matchBlocks
        ];
      };
    }
  ]);
}

