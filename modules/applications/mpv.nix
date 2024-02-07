{ config, lib, pkgs, system, username, ... }:
let
  inherit (lib)
    mkIf
    mkEnableOption
    mkMerge
    mkOption
    types;

  cfg = config.apps.mpv;
in
{
  options.apps.mpv = {
    enable = mkEnableOption ''
      mpv with sane defaults for hardware acceleration
    '';

    config = mkOption {
      type = types.attrs;
      default = { };
    };
  };

  config = mkIf cfg.enable {
    hm.programs.mpv = {
      enable = true;
      config =
        {
          profile = "gpu-hq";
          hwdec = "auto-safe";
          vo = "gpu";
          force-window = true;
          ytdl-format = "bestvideo+bestaudio";
          cache-default = 4000000;
        } // cfg.config;
    };
  };
}
