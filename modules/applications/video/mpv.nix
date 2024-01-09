{ config, lib, pkgs, username, ... }:
let
  cfg = config.apps.mpv;
in
with lib;
{
  options.apps.mpv = {
    enable = mkEnableOption "mpv";
  };

  config = mkIf cfg.enable {
    home-manager.users.${username} = {
      programs.mpv = {
        enable = true;
        config = {
          profile = "gpu-hq";
          hwdec = "auto-safe";
          vo = "gpu";
          force-window = true;
          ytdl-format = "bestvideo+bestaudio";
          cache-default = 4000000;
        } // (
          if config.compositors.wayland.enable
          then { gpu-context = "wayland"; }
          else { }
        );
      };

    };
  };
}
