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
        # compositors.wayland.enable = true;

        serve.avahi.enable = true;
        serve.printing.enable = true;
        serve.samba.enable = true;
        serve.ssh.enable = true;

        hardware.pulseaudio.enable = false;

        services.xserver.enable = true;
        services.xserver.displayManager.gdm.enable = true;
        services.xserver.desktopManager.gnome.enable = true;
        services.xserver.libinput = {
          enable = true;
        };

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
