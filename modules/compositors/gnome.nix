{ config
, lib
, pkgs
, system
, username
, ...
}:
let
  cfg = config.compositors.gnome;
in
{
  options.compositors.gnome = {
    enable = lib.mkEnableOption "sway wm";
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    (
      if !(builtins.elem system [ "aarch64-darwin" "x86_64-darwin" ])
      then {
        # compositors.minimal.enable = true;
        # compositors.appearance.enable = true;

        # GNOME
        hardware.pulseaudio.enable = false;
        services.xserver.enable = true;
        services.xserver.displayManager.gdm.enable = true;
        services.xserver.desktopManager.gnome.enable = true;
        services.xserver.libinput.enable = true;

        services.gnome.gnome-browser-connector.enable = true;

        services.gnome.tracker-miners.enable = false;
        services.gnome.tracker.enable = false;

        environment.gnome.excludePackages =
          (with pkgs; [
            gnome-tour
            gnome-console
          ])
          ++ (with pkgs.gnome; [
            gnome-music
            gnome-terminal
            epiphany # web browser
            geary # email reader
            # evince # document viewer
            gnome-characters
            totem # video player
            tali # poker game
            iagno # go game
            hitori # sudoku game
            atomix # puzzle game
          ]);

        # GNOME 45: triple-buffering-v4-45
        nixpkgs.overlays = [
          (final: prev: {
            gnome = prev.gnome.overrideScope' (gnomeFinal: gnomePrev: {
              mutter = gnomePrev.mutter.overrideAttrs (old: {
                src = pkgs.fetchgit {
                  url = "https://gitlab.gnome.org/vanvugt/mutter.git";
                  rev = "0b896518b2028d9c4d6ea44806d093fd33793689";
                  sha256 = "sha256-mzNy5GPlB2qkI2KEAErJQzO//uo8yO0kPQUwvGDwR4w=";
                };
              });
            });
          })
        ];
        # nixpkgs.config.allowAliases = false;

        # Autologin
        services.xserver.displayManager.autoLogin.enable = true;
        services.xserver.displayManager.autoLogin.user = "${username}";

        systemd.services."getty@tty1".enable = false;
        systemd.services."autovt@tty1".enable = false;

        # Custom defaults apps and services

        apps.valent.enable = true;
        apps.ulauncher.enable = true;

        # Useful packages and extensions
        environment.systemPackages = with pkgs; [
          gnome.gnome-tweaks
          gnomeExtensions.clipboard-indicator
          gnomeExtensions.dash-to-dock
          gnomeExtensions.disable-workspace-switcher
          gnomeExtensions.move-clock
          gnomeExtensions.notification-banner-position
          waypipe
          wl-clipboard
          evolution
          gnome.evolution-data-server
        ];

        home-manager.users.${username} = with lib.hm.gvariant; {
          dconf.settings = {
            "org/gnome/desktop/input-sources" = {
              mru-sources = [ (mkTuple [ "xkb" "us" ]) ];
              show-all-sources = false;
              sources = [ (mkTuple [ "xkb" "us+altgr-intl" ]) (mkTuple [ "xkb" "ru" ]) ];
              xkb-options = [
                "terminate:ctrl_alt_bksp"
                "caps:ctrl_modifier"
                "mod_led:compose"
                "lv3:ralt_switch"
                "compose:ralt"
              ];
            };

            "org/gnome/desktop/peripherals/mouse" = {
              natural-scroll = false;
            };

            "org/gnome/desktop/peripherals/touchpad" = {
              tap-and-drag = false;
              tap-to-click = true;
              two-finger-scrolling-enabled = true;
            };

            "org/gnome/desktop/wm/keybindings" = {
              move-to-workspace-1 = [ "<Shift><Super>1" ];
              move-to-workspace-2 = [ "<Shift><Super>2" ];
              move-to-workspace-3 = [ "<Shift><Super>3" ];
              move-to-workspace-4 = [ "<Shift><Super>4" ];
              move-to-workspace-5 = [ "<Shift><Super>5" ];
              switch-to-workspace-1 = [ "<Super>1" ];
              switch-to-workspace-2 = [ "<Super>2" ];
              switch-to-workspace-3 = [ "<Super>3" ];
              switch-to-workspace-4 = [ "<Super>4" ];
              switch-to-workspace-5 = [ "<Super>5" ];
            };

            "org/gnome/desktop/wm/preferences" = {
              action-middle-click-titlebar = "menu";
              button-layout = "close:appmenu";
              focus-mode = "click";
              resize-with-right-button = false;
              titlebar-font = "SF Compact Display Medium 11";
            };

            "org/gnome/file-roller/dialogs/extract" = {
              recreate-folders = true;
              skip-newer = false;
            };

            "org/gnome/file-roller/listing" = {
              list-mode = "as-folder";
              name-column-width = 250;
              show-path = false;
              sort-method = "name";
              sort-type = "ascending";
            };

            "org/gnome/mutter" = {
              center-new-windows = true;
            };

            "org/gnome/nautilus/icon-view" = {
              default-zoom-level = "small";
            };

            "org/gnome/nautilus/list-view" = {
              default-zoom-level = "small";
              use-tree-view = true;
            };

            "org/gnome/nautilus/preferences" = {
              default-folder-viewer = "list-view";
              migrated-gtk-settings = true;
              search-filter-time-type = "last_modified";
            };

            "org/gnome/shell" = {
              disabled-extensions = [
                "light-style@gnome-shell-extensions.gcampax.github.com"
                "apps-menu@gnome-shell-extensions.gcampax.github.com"
              ];
              enabled-extensions = [
                "disable-workspace-switcher@jbradaric.me"
                "launch-new-instance@gnome-shell-extensions.gcampax.github.com"
                "disable-workspace-switcher-overlay@cleardevice"
                "disable-workspace-animation@ethnarque"
                "Move_Clock@rmy.pobox.com"
                "notification-position@drugo.dev"
                "legacyschemeautoswitcher@joshimukul29.gmail.com"
                "valent@andyholmes.ca"
                "clipboard-indicator@tudmotu.com"
                "dash-to-dock@micxgx.gmail.com"
              ];
              favorite-apps = [ "org.gnome.Nautilus.desktop" "org.gnome.Calendar.desktop" "firefox.desktop" ];
            };

            "org/gnome/shell/extensions/clipboard-indicator" = {
              clear-on-boot = true;
              confirm-clear = false;
              display-mode = 3;
              history-size = 10;
              move-item-first = true;
              notify-on-copy = false;
              strip-text = true;
              toggle-menu = [ "Favorites" ];
            };

            "org/gnome/shell/extensions/dash-to-dock" = {
              animate-show-apps = true;
              apply-custom-theme = false;
              background-opacity = 0.25;
              custom-theme-shrink = true;
              dash-max-icon-size = 48;
              dock-position = "BOTTOM";
              height-fraction = 0.9;
              hide-tooltip = false;
              hot-keys = false;
              max-alpha = 0.8;
              preferred-monitor = -2;
              preferred-monitor-by-connector = "eDP-1";
              running-indicator-style = "DASHES";
              scroll-action = "cycle-windows";
              show-favorites = true;
              show-icons-notifications-counter = true;
              show-mounts-network = true;
              show-show-apps-button = false;
              transparency-mode = "DYNAMIC";
            };

            "org/gnome/shell/keybindings" = {
              switch-to-application-1 = [ ];
              switch-to-application-2 = [ ];
              switch-to-application-3 = [ ];
              switch-to-application-4 = [ ];
              switch-to-application-5 = [ ];
            };

            "org/gnome/tweaks" = {
              show-extensions-notice = false;
            };
          };
        };
      }
      else { }
    )
  ]);
}
