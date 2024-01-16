{
  config,
  lib,
  pkgs,
  system,
  username,
  ...
}: let
  cfg = config.compositors.gnome;
in {
  options.compositors.gnome = {
    enable = lib.mkEnableOption "sway wm";
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    (
      if !(builtins.elem system ["aarch64-darwin" "x86_64-darwin"])
      then {
        compositors.minimal.enable = true;
        compositors.interface.enable = true;

        # GNOME
        services.xserver.enable = true;
        services.xserver.displayManager.gdm.enable = true;
        services.xserver.desktopManager.gnome.enable = true;
        services.xserver.libinput.enable = true;

        services.gnome.gnome-browser-connector.enable = true;

        hardware.pulseaudio.enable = false;

        environment.gnome.excludePackages =
          (with pkgs; [
            gnome-tour
          ])
          ++ (with pkgs.gnome; [
            # gnome-music
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

        # Useful packages
        environment.systemPackages = with pkgs; [
          gnome.gnome-tweaks
          gnomeExtensions.blur-my-shell
          gnomeExtensions.clipboard-indicator
          gnomeExtensions.disable-workspace-switcher
          gnomeExtensions.move-clock
          gnomeExtensions.notification-banner-position
          waypipe
          wl-clipboard
        ];

        # Custom defaults
        services'.avahi.enable = true;
        services'.printing.enable = true;
        services'.samba.enable = true;
        services'.ssh.enable = true;

        apps.valent.enable = true;
        apps.ulauncher.enable = true;
      }
      else {}
    )
  ]);
}
