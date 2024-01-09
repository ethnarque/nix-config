{ config, lib, pkgs, username, ... }:
with lib;
let
  cfg = config.apps.tmux;
in
{
  options.apps.tmux = {
    enable = mkEnableOption "tmux cli";
  };

  config = mkIf cfg.enable {
    home-manager.users.${username} = {
      programs.tmux = {
        enable = true;
        baseIndex = 1;
      };
    };
  };
}
