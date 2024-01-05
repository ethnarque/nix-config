{ config, lib, pkgs, system, username, ... }:
let
  cfg = config.compositors.sway;

  dbus-sway-environment = pkgs.writeTextFile {
    name = "dbus-sway-environment";
    destination = "/bin/dbus-sway-environment";
    executable = true;

    text = ''
      dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
      systemctl --user stop pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
      systemctl --user start pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
    '';
  };
in
{
  options.compositors.sway = {
    enable = lib.mkEnableOption "sway wm";
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    (if !(builtins.elem system [ "aarch64-darwin" "x86_64-darwin" ]) then
      {
        compositors.wayland.enable = true;

        programs.sway = {
          enable = true;
          package = null;
          wrapperFeatures.gtk = true;
        };

        services.dbus.enable = true;
        security.polkit.enable = true;

        environment.systemPackages = with pkgs; [
          dbus-sway-environment
          pulseaudio
          gnome.adwaita-icon-theme
          gsettings-desktop-schemas
          wayland
          xdg-utils # for opening default programs when clicking links
          glib # gsettings
          #   dracula-theme # gtk theme
          #   gnome3.adwaita-icon-theme # default gnome cursors
          swaylock
          swayidle
          #   wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
          #   bemenu # wayland clone of dmenu
          #   mako # notification system developed by swaywm maintainer
          #   wdisplays # tool to configure displays
        ];

        xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

        home-manager.users.${username} = { config, ... }: {
          dconf.enable = true;
          dconf.settings = {
            # "org/gnome/desktop/interface".color-scheme = "prefer-dark";
            "org/gnome/desktop/interface".font-name = "SF Pro";
          };

          home.packages = with pkgs; [
            slurp
            grim
            wl-clipboard
            waypipe
          ];

          home.pointerCursor = {
            name = "Adwaita";
            package = pkgs.gnome.adwaita-icon-theme;
            size = 24;
            x11 = {
              enable = true;
              defaultCursor = "Adwaita";
            };
          };

          programs.waybar.enable = true;

          wayland.windowManager.sway = {
            enable = true;
            extraSessionCommands = ''
              . "${config.home.profileDirectory}/etc/profile.d/hm-session-vars.sh"
            '';
            config = rec {
              bars = [ ];
              modifier = "Mod4";
              # Use kitty as default terminal
              terminal = "${pkgs.kitty}/bin/kitty --single-instance";
              startup = [
                # Launch Firefox on start
                { command = "firefox"; }
                { command = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"; }
              ];
              keybindings =
                let
                  pactl = "${pkgs.pulseaudio}/bin/pactl";
                  light = "${pkgs.light}/bin/light";
                in
                lib.mkOptionDefault {
                  # audio keys
                  XF86AudioMute = "exec ${pactl} set-sink-mute 0 toggle";
                  XF86AudioLowerVolume = "exec ${pactl} set-sink-volume 0 -5%";
                  XF86AudioRaiseVolume = "exec ${pactl} set-sink-volume 0 +5%";
                  XF86AudioMicMute = "exec ${pactl} set-source-mute 0 toggle";

                  XF86MonBrightnessUp = "exec ${light} -A 5";
                  XF86MonBrightnessDown = "exec ${light} -U 5";
                };
              workspaceAutoBackAndForth = true;
            };
            extraConfig = ''
              default_border pixel 1

              bar {
                swaybar_command waybar
              }

              exec dbus-sway-environment
              exec configure-gtk
            '';
          };
        };
      }
    else
      { })
  ]);
}
