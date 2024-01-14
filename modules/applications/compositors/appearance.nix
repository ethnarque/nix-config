{
  config,
  lib,
  options,
  pkgs,
  system,
  username,
  ...
}:
with lib; let
  cfg = config.compositors.interface;
in {
  options.compositors.interface = {
    enable = lib.mkEnableOption "appearance";

    fonts = {
      packages = mkOption {
        type = with types; listOf package;
        default = with pkgs; [];
      };

      sans = {
        name = mkOption {
          type = types.str;
          default = "DejaVu Sans";
        };

        size = mkOption {
          type = types.int;
          default = 12;
        };
      };

      serif = {
        name = mkOption {
          type = types.str;
          default = "Liberation Serif";
        };

        size = mkOption {
          type = types.int;
          default = 11;
        };
      };

      monospace = {
        name = mkOption {
          type = types.str;
          default = "Source Code Pro";
        };

        size = mkOption {
          type = types.int;
          default = 11;
        };
      };
    };

    icons = {
      package = mkOption {
        type = types.package;
        default = pkgs.morewaita-icon-theme;
      };

      name = mkOption {
        type = with types; nullOr str;
        default = "MoreWaita";
      };

      darkTheme = mkOption {
        type = with types; nullOr str;
        default = null;
      };

      lightTheme = mkOption {
        type = with types; nullOr str;
        default = null;
      };
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    (
      if !(builtins.elem system ["aarch64-darwin" "x86_64-darwin"])
      then {
        fonts = {
          fontconfig.enable = true;
          fontDir.enable = true;
          packages = cfg.fonts.packages;
        };

        environment.systemPackages = with pkgs; [
        ];

        home-manager.users.${username} = {
          gtk = {
            enable = true;
            font = {
              name = cfg.fonts.sans.name;
              size = cfg.fonts.sans.size;
            };
            iconTheme = {
              package = cfg.icons.package;
              name = cfg.icons.name;
            };
          };
        };
      }
      else {
        fonts.fonts = cfg.fonts.packages;
      }
    )
  ]);
}
