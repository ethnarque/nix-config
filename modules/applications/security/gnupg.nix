{ config, lib, pkgs, system, username, ... }:
let
  inherit (lib)
    isDarwin
    optionalAttrs
    mkEnableOption
    mkIf
    mkMerge
    mkOption
    types;

  cfg = config.apps.gnupg;
in
{
  options.apps.gnupg = {
    enable = mkEnableOption "password-store";

    enableSSHSupport = mkOption {
      type = types.bool;
      default = true;
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      programs.gnupg.agent = {
        enable = true;
        enableSSHSupport = cfg.enableSSHSupport;
      };
    }

    (optionalAttrs (isDarwin system) {
      environment.systemPackages = with pkgs;[
        gnupg
      ];
    })
  ]);
}
