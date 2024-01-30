{ config, lib, pkgs, system, username, ... }:
let
  inherit (lib)
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
    (
      if !(builtins.elem system [ "aarch64-darwin" "x86_64-darwin" ])
      then { }
      else {
        environment.systemPackages = with pkgs;[
          gnupg
        ];
      }
    )
  ]);
}
