{ config, lib, pkgs, username, ... }:
with lib;
let
  cfg = config.modules.gtk;
in
{
  options.modules.gtk = {
    enable = mkEnableOption "tmux cli";
  };

  config = mkIf cfg.enable {
    home-manager.users.${username} = {
      gtk.enable = true;
      # gtk.font = {
      #   name = "SF Pro";
      # };
    };
  };
}
