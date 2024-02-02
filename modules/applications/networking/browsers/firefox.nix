{ config, inputs, lib, options, pkgs, username, system, ... }:
let
  inherit (lib)
    isDarwin
    isLinux
    optionalAttrs
    mkAfter
    mkEnableOption
    mkIf
    mkMerge
    mkOption
    types;

  cfg = config.apps.firefox;

  defaultSettings = {
    "browser.startup.page" = 3;
    "browser.formfill.enable" = false;
    "browser.download.useDownloadDir" = false;
    "gfx.webrender.all" = true;
    "media.ffmpeg.vaapi.enabled" = true;
    "media.ffvpx.enabled" = false;
    "media.rdd-vpx.enabled" = false;
    "media.navigator.mediadatadecoder_vpx_enabled" = true;
    "services.sync.prefs.sync.browser.formfill.enable" = false;
    "signon.rememberSignons" = false;
    "signon.prefillForms" = false;
  };
in
{
  options.apps.firefox = {
    enable = mkEnableOption "firefox web browser";

    package = mkOption {
      type = with types; nullOr package;
      default = pkgs.firefox;
    };

    bookmarks = mkOption {
      type = with types; listOf attrs;
      default = [ ];
    };

    extensions = mkOption {
      type = with types; listOf package;
      default = [ ];
    };

    settings = mkOption {
      type = types.attrs;
      default = { };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      home-manager.users.${username} = {
        programs.firefox = {
          enable = true;

          policies = {
            EnableTrackingProtection = true;
            SearchEngines = {
              Default = "DuckDuckGo";
            };
          };

          profiles.${username} = {
            id = 0;
            isDefault = true;
            name = username;

            search.force = true;

            bookmarks =
              [
                {
                  name = "YouTube";
                  tags = [ "youtube" ];
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
                (optionalAttrs (config.apps.pass.enable) browserpass)
              ]
              ++ cfg.extensions;

            search = {
              default = "DuckDuckGo";
            };

            settings = defaultSettings // cfg.settings;
          };

          profiles."downloader" = {
            id = 1;
            name = "downloader";

            search.force = true;

            extensions = with config.nur.repos.rycee.firefox-addons;
              [
                ublock-origin
                search-by-image
                (optionalAttrs (config.apps.pass.enable) browserpass)
              ]
              ++ cfg.extensions;

            settings = defaultSettings // mkAfter { };
          };
        };
      };
    }

    (optionalAttrs (isLinux system) {
      programs.browserpass.enable = true;

      home-manager.users.${username}.programs.firefox = {
        package = pkgs.firefox.override {
          nativeMessagingHosts = with pkgs;[
            (optionalAttrs (config.compositors.gnome.enable)
              gnome-browser-connector)

            (optionalAttrs (config.apps.pass.enable)
              browserpass)
          ];
        };
      };
    })

    (optionalAttrs (isDarwin system) {
      home-manager.users.${username} = {
        programs.firefox.package = pkgs.callPackage ../../../../packages/firefox.nix { };

        # TODO: Make a function in gnupg module in order to concat strings
        home.file.".gnupg/gpg-agent.conf".text = ''
          pinentry-program ${pkgs.pinentry_mac}/Applications/pinentry-mac.app/Contents/MacOS/pinentry-mac
        '';
      };

      # Install browserpass native to connect to the password
      # TODO: Needs to change manually the password pass in the extensions settings
      system.activationScripts.extraUserActivation.text = mkIf config.apps.pass.enable
        ''
          install -d -o ${username} -g staff $HOME/Library/Application\ Support/Mozilla/NativeMessagingHosts
          ln -sf \
             ${pkgs.browserpass}/lib/mozilla/native-messaging-hosts/com.github.browserpass.native.json \
             $HOME/Library/Application\ Support/Mozilla/NativeMessagingHosts/com.github.browserpass.native.json

          install -d -o ${username} -g staff $HOME/Library/Application\ Support/Orion/NativeMessagingHosts
          ln -sf \
             ${pkgs.browserpass}/lib/mozilla/native-messaging-hosts/com.github.browserpass.native.json \
             $HOME/Library/Application\ Support/Orion/NativeMessagingHosts/com.github.browserpass.native.json
        '';
    })
  ]);
}
