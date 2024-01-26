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

    settings = mkOption {
      type = types.attrs;
      default = {};
    };
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      programs.firefox = {
        enable = true;
        package = pkgs.firefox.override {
          nativeMessagingHosts = [
            (optionalAttrs (config.compositors.gnome.enable) [
              pkgs.gnome-browser-connector
            ])
            (optionalAttrs (config.apps.pass.enable) [
              pkgs.passff-host
            ])
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
            [
              {
                name = "YouTube";
                tags = ["youtube"];
                keyword = "youtube";
                url = "https://youtube.com";
              }
            ]
            ++ cfg.bookmarks;

          extensions = with config.nur.repos.rycee.firefox-addons;
            [
              bitwarden
              ublock-origin
              search-by-image
              (optionalAttrs (config.apps.pass.enable) passff)
            ]
            ++ cfg.extensions;

          search = {
            default = "DuckDuckGo";
          };

          settings =
            {
              "browser.startup.page" = 3;
              "gfx.webrender.all" = true;
              "media.ffmpeg.vaapi.enabled" = true;
              "media.ffvpx.enabled" = false;
              "media.rdd-vpx.enabled" = false;
              "media.navigator.mediadatadecoder_vpx_enabled" = true;
            }
            // cfg.settings;
        };
      };
    };
  };
}
