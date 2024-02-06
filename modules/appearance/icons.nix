{ config, lib, options, pkgs, system, username, ... }:

let
  inherit (lib)
    isDarwin
    isLinux
    mkBefore
    mkIf
    mkEnableOption
    mkMerge
    mkOption
    optionalAttrs
    types;

  cfg = config.appearance.icons;
in
{
  options.appearance.icons = {
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

  config = mkIf config.machine.linux.gnome.enable (mkMerge [
    (optionalAttrs (isLinux system) {
      environment.systemPackages = with pkgs;[
        gnome.adwaita-icon-theme
      ];

      hm.gtk = {
        enable = true;

        iconTheme = {
          package = cfg.package;
          name = cfg.name;
        };
      };
    })

    (optionalAttrs (isDarwin system) {
      homebrew.casks = [
        "sf-symbols"
      ];
    })
  ]);
}
