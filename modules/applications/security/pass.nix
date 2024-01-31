{ config, lib, pkgs, system, username, ... }:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkMerge;

  cfg = config.apps.pass;
in
{
  options.apps.pass = {
    enable = mkEnableOption "password-store";
  };

  config = mkIf cfg.enable (mkMerge [
    {
      home-manager.users.${username} = {
        programs.password-store = {
          enable = true;
          settings = {
            PASSWORD_STORE_CLIP_TIME = "60";
          };
        };
      };
    }
  ]);
}
