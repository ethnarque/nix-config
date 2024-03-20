{ config, lib, options, pkgs, system, username, ... }:
let
  inherit (lib)
    isDarwin
    isLinux
    mkMerge
    mkIf
    mkOption
    optionalAttrs
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

  config = mkIf  config.machine.darwin.enable (mkMerge [
    (optionalAttrs (isLinux system) {
      fonts = {
        fontconfig.enable = true;
        # packages = cfg.packages ++ [ ];
      };

      hm.gtk = {
        enable = true;
        font = {
          name = cfg.sans.name;
          size = cfg.sans.size;
        };
      };

    })

    (optionalAttrs (isDarwin system) {
      # fonts.fonts = cfg.packages ++ [ ];
    })

    {
      fonts.fontDir.enable = true;
      hm.fonts.fontconfig.enable = true;
      hm.home.packages = [ ] ++ cfg.packages;
    }
  ]);
}
