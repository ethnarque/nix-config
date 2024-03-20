{ config, lib, pkgs, username, ... }:

let
  inherit (lib)
    mkIf
    mkEnableOption
    mkMerge
    mkOption
    types;

  cfg = config.apps.kitty;
in
{
  options.apps.kitty = {
    enable = mkEnableOption "kitty terminal";

    font = {
      name = mkOption {
        type = types.str;
        default = config.appearance.fonts.monospace.name;
      };

      size = mkOption {
        type = types.float;
        default = config.appearance.fonts.monospace.size;
      };
    };
  };

  config = mkIf cfg.enable {
    appearance = {
      darkModeScripts = {
        kitty = ''
          ${pkgs.kitty}/bin/kitty +kitten themes --reload-in=all --config-file-name "current_theme.conf" Rosé\ Pine
        '';
      };
      lightModeScripts = {
        kitty = ''
          ${pkgs.kitty}/bin/kitty +kitten themes --reload-in=all --config-file-name "current_theme.conf" Rosé\ Pine\ Dawn
        '';
      };
    };

    hm.home.file."kitty-themes" = {
      source = ./themes;
      target = ".config/kitty/themes";
      recursive = true;
    };

    hm.programs.kitty = {
      enable = true;

      theme = "Rosé Pine";

      font = {
        name = cfg.font.name;
        size = cfg.font.size;
      };

      settings = {
        font_features = "none";
        enable_audio_bell = false;
        allow_remote_control = true;
        update_check_interval = 0;
        window_padding_width = 6;
        hide_window_decorations =
          if pkgs.stdenv.isDarwin
          then "titlebar-only"
          else false;
        macos_quit_when_last_window_closed = false;
        macos_option_as_alt = false;
        wayland_titlebar_color = "background";
      };

      extraConfig = ''
        include current_theme.conf
      '';

      shellIntegration.enableZshIntegration = true;
    };
  };
}
