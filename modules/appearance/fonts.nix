{ config, lib, options, pkgs, system, username, ... }:
let
  inherit (lib)
    mkMerge
    mkIf
    mkOption
    types;

  cfg = config.appearance.fonts;
in
{
  options.appearance.fonts = {
    packages = mkOption {
      type = with types; listOf package;
      default = with pkgs; [ ];
    };

    sans = {
      name = mkOption {
        type = types.str;
        default = "DejaVu Sans";
      };

      size = mkOption {
        type = types.float;
        default = 12.0;
      };
    };

    serif = {
      name = mkOption {
        type = types.str;
        default = "Liberation Serif";
      };

      size = mkOption {
        type = types.float;
        default = 11.0;
      };
    };

    monospace = {
      name = mkOption {
        type = types.str;
        default = "Source Code Pro";
      };

      size = mkOption {
        type = types.float;
        default = 11.0;
      };
    };
  };

  config = mkIf config.machine.darwin.enable or config.machine.linux.enable (mkMerge [
    { fonts.fontDir.enable = true; }
    (
      if !(builtins.elem system [ "aarch64-darwin" "x86_64-darwin" ])
      then {
        fonts = {
          fontconfig.enable = true;
          packages = cfg.packages ++ [ ];
        };

        home-manager.users.${username} = {
          gtk = {
            enable = true;
            font = {
              name = cfg.sans.name;
              size = cfg.sans.size;
            };
          };
        };
      }
      else {
        fonts.fonts = cfg.packages ++ [ ];
      }
    )
  ]);
}
