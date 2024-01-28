{ config
, lib
, pkgs
, system
, username
, ...
}:
with lib; let
  cfg = config.services'.ssh;
in
{
  options.services'.ssh = {
    enable = mkEnableOption "ssh services";

    matchBlocks = mkOption {
      type = types.nullOr types.attrs;
      default = { };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    (
      if !(builtins.elem system [ "aarch64-darwin" "x86_64-darwin" ])
      then {
        networking.firewall.allowedTCPPorts = [ 22 ];
        services.openssh.enable = true;
      }
      else { }
    )

    {
      home-manager.users.${username} = {
        programs.ssh = {
          enable = true;
          matchBlocks =
            cfg.matchBlocks
            // {
              "github.com" = {
                hostname = "github.com";
                identityFile = "~/.ssh/id_ed25519.github";
              };

              "ethnarque.co" = {
                hostname = "ethnarque.co";
                identityFile = "~/.ssh/id_ed25519.hetzner";
              };
            };
        };
      };
    }
  ]);
}
