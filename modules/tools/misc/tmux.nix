{ config, lib, pkgs, username, ... }:
with lib;
let
  cfg = config.modules.tmux;
in
{
  options.modules.tmux = {
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
