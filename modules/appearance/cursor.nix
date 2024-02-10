{ config, lib, options, pkgs, system, username, ... }:

let
  inherit (lib)
    isLinux
    optionalAttrs
    mkEnableOption
    mkIf
    mkMerge
    mkOption
    types;

  cfg = config.appearance.cursor;
in
{
  options.appearance.cursor = {
    package = mkOption {
      type = types.package;
      default = pkgs.gnome.adwaita-icon-theme;
    };

    name = mkOption {
      type = with types; nullOr str;
      default = "Adwaita";
    };

    size = mkOption {
      type = types.int;
      default = 24;
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

  config = mkIf config.machine.linux.gnome.enable (mkMerge [
    (optionalAttrs (isLinux system) {
      hm.home.pointerCursor = {
        name = cfg.name;
        package = cfg.package;
        size = cfg.size;
        x11 = {
          enable = true;
          defaultCursor = cfg.name;
        };
      };
    })
  ]);
}
