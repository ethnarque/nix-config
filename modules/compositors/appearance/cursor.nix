{ config
, lib
, options
, pkgs
, system
, username
, ...
}:
with lib; let
  cfg = config.compositors.appearance.cursor;
in
{
  options.compositors.appearance.cursor = {
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

  config = mkIf config.compositors.appearance.enable (mkMerge [
    (
      if !(builtins.elem system [ "aarch64-darwin" "x86_64-darwin" ])
      then {
        home-manager.users.${username} = {
          home.pointerCursor = {
            name = cfg.name;
            package = cfg.package;
            size = cfg.size;
            x11 = {
              enable = true;
              defaultCursor = cfg.name;
            };
          };
        };
      }
      else { }
    )
  ]);
}
