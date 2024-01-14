{
  config,
  inputs,
  lib,
  options,
  pkgs,
  username,
  ...
}:
with lib; let
  cfg = config.apps.firefox;
in {
  options.apps.firefox = {
    enable = mkEnableOption "firefox web browser";

    package = mkOption {
      type = with types; nullOr package;
      default = pkgs.firefox;
    };

    bookmarks = mkOption {
      type = with types; listOf attrs;
      default = {};
    };

    extensions = mkOption {
      type = with types; listOf package;
      default = [];
    };
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      programs.firefox = {
        enable = true;
        package = pkgs.firefox.override {
          nativeMessagingHosts = [
            pkgs.gnome-browser-connector
          ];
        };
        policies = {
          EnableTrackingProtection = true;
          PromptForDownloadLocation = true;
          SearchEngines = {
            Default = "DuckDuckGo";
          };
        };

        profiles.${username} = {
          id = 0;
          isDefault = true;
          name = username;

          bookmarks =
            cfg.bookmarks
            ++ [
              {
                name = "YouTube";
                tags = ["youtube"];
                keyword = "youtube";
                url = "https://youtube.com";
              }
            ];

          extensions = with config.nur.repos.rycee.firefox-addons;
            cfg.extensions
            ++ [
              bitwarden
              ublock-origin
              search-by-image
            ];

          search = {
            default = "DuckDuckGo";
          };

          settings = {
            "browser.startup.page" = 3;
            "gfx.webrender.all" = true;
            "media.ffmpeg.vaapi.enabled" = true;
            "media.ffvpx.enabled" = false;
            "media.rdd-vpx.enabled" = false;
            "media.navigator.mediadatadecoder_vpx_enabled" = true;
          };
        };
      };
    };
  };
}
