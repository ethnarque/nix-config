{ config
, lib
, options
, pkgs
, system
, username
, ...
}:
with lib; let
  cfg = config.compositors.interface.icons;
in
{
  options.compositors.interface.icons = {
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

  config = mkIf config.compositors.interface.enable (mkMerge [
    (
      if !(builtins.elem system [ "aarch64-darwin" "x86_64-darwin" ])
      then {
        environment.systemPackages = with pkgs; [
          gnome.adwaita-icon-theme # MoreWaita extends from Adwaita icons
        ];
        home-manager.users.${username} = {
          gtk = {
            enable = true;
            iconTheme = {
              package = cfg.package;
              name = cfg.name;
            };
          };
        };
      }
      else { }
    )
  ]);
}
