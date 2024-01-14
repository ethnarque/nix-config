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

        serve.avahi.enable = true;
        serve.printing.enable = true;
        serve.samba.enable = true;
        serve.ssh.enable = true;

        apps.ulauncher.enable = true;

        hardware.pulseaudio.enable = false;

        services.xserver.enable = true;
        services.xserver.displayManager.gdm.enable = true;
        services.xserver.desktopManager.gnome.enable = true;
        services.xserver.libinput = {
          enable = true;
        };

        nixpkgs.overlays = [
          (final: prev: {
            gnome = prev.gnome.overrideScope' (gnomeFinal: gnomePrev: {
              mutter = gnomePrev.mutter.overrideAttrs (old: {
                src = pkgs.fetchgit {
                  url = "https://gitlab.gnome.org/vanvugt/mutter.git";
                  # GNOME 45: triple-buffering-v4-45
                  rev = "0b896518b2028d9c4d6ea44806d093fd33793689";
                  sha256 = "sha256-mzNy5GPlB2qkI2KEAErJQzO//uo8yO0kPQUwvGDwR4w=";
                };
              });
            });
          })
        ];
        # nixpkgs.config.allowAliases = false;
        services.xserver.displayManager.autoLogin.enable = true;
        services.xserver.displayManager.autoLogin.user = "pml";

        systemd.services."getty@tty1".enable = false;
        systemd.services."autovt@tty1".enable = false;
        services.gnome.gnome-browser-connector.enable = true;

        environment.gnome.excludePackages =
          (with pkgs; [
            gnome-tour
          ])
          ++ (with pkgs.gnome; [
            gnome-music
            gnome-terminal
            epiphany # web browser
            geary # email reader
            evince # document viewer
            gnome-characters
            totem # video player
            tali # poker game
            iagno # go game
            hitori # sudoku game
            atomix # puzzle game
          ]);

        home-manager.users.${username} = {
          home.packages = with pkgs; [
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
        };
      }
      else {}
    )
  ]);
}
