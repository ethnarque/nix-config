{
  config,
  lib,
  pkgs,
  username,
  ...
}:
with lib; let
  cfg = config.apps.kitty;
in {
  options.apps.kitty = {
    enable = mkEnableOption "kitty terminal";
    font = {
      name = mkOption {
        type = types.str;
        default = config.compositors.interface.fonts.monospace.name;
      };

      size = mkOption {
        type = types.float;
        default = config.compositors.interface.fonts.monospace.size;
      };
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.${username} = {
      programs.kitty = {
        enable = true;

        theme = "Rosé Pine";

        font = {
          name = cfg.font.name;
          size = cfg.font.size;
        };

        settings = {
          enable_audio_bell = false;
          allow_remote_control = true;
          update_check_interval = 0;
          window_padding_width = 12;
          hide_window_decorations =
            if pkgs.stdenv.isDarwin
            then "titlebar-only"
            else false;
          macos_quit_when_last_window_closed = false;
          macos_option_as_alt = false;
          wayland_titlebar_color = "system";
        };

        extraConfig = ''
          include current_theme.conf
        '';

        shellIntegration.enableZshIntegration = true;
      };

      services.darkman = {
        enable = true;

        settings = {
          lat = 45.7;
          lng = 4.9;
          usegeoclue = true;
        };

        darkModeScripts = {
          gtk-theme = ''
            ${pkgs.dconf}/bin/dconf write \
                /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
          '';
          kitty = ''
            ${pkgs.kitty}/bin/kitty +kitten themes --reload-in=all --config-file-name "current_theme.conf" Rosé\ Pine
          '';
        };
        lightModeScripts = {
          gtk-theme = ''
            ${pkgs.dconf}/bin/dconf write \
                /org/gnome/desktop/interface/color-scheme "'prefer-light'"
          '';
          kitty = ''
            ${pkgs.kitty}/bin/kitty +kitten themes --reload-in=all --config-file-name "current_theme.conf" Rosé\ Pine\ Dawn
          '';
        };
      };
    };
  };
}
