{ config
, lib
, pkgs
, username
, ...
}:
let
  cfg = config.apps.mpv;
in
with lib; {
  options.apps.mpv = {
    enable = mkEnableOption ''
      mpv with sane defaults for hardware acceleration
    '';
    config = mkOption {
      type = with types; nullOr attrs;
      default = null;
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.${username} = {
      programs.mpv = {
        enable = true;
        config =
          {
            profile = "gpu-hq";
            hwdec = "auto-safe";
            vo = "gpu";
            force-window = true;
            ytdl-format = "bestvideo+bestaudio";
            cache-default = 4000000;
          }
          // cfg.config;
      };
    };
  };
}
