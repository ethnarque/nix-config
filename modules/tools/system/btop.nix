{ config, lib, pkgs, username, ... }:
let
  cfg = config.apps.btop;
in
{
  options.apps.btop = {
    enable = lib.mkEnableOption "btop";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      programs.btop.enable = true;
    };
  };
}

