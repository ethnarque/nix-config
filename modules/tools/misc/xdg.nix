{ config, lib, pkgs, username, ... }:
with lib;
let
  cfg = config.modules.xdg;
in
{
  options.modules.xdg = {
    enable = mkEnableOption "xdg";
  };

  config = mkIf cfg.enable {
    home-manager.users.${username} = {
      xdg.enable = true;
    };
  };
}
