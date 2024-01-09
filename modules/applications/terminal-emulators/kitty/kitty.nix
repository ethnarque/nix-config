{ config, lib, pkgs, username, ... }:
let
  cfg = config.apps.kitty;
in
{
  options.apps.kitty = {
    enable = lib.mkEnableOption "kitty terminal";
    font = {
      name = lib.mkOption {
        type = lib.types.str;
        default = "Iosevka";
      };

      size = lib.mkOption {
        type = lib.types.float;
        default = 11.0;
      };
    };
  };

  config = lib.mkIf cfg.enable {
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
          hide_window_decorations = "titlebar-only";
          macos_quit_when_last_window_closed = false;
          macos_option_as_alt = false;
        };
        shellIntegration.enableZshIntegration = true;
      };
    };
  };

}
