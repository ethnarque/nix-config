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
  cfg = config.appearance;
in {
  options.appearance = {
    enable = lib.mkEnableOption "kitty terminal";

    font = {
      sans = {
        name = mkOption {
          type = types.str;
          package = types.package;
        };
        package = mkOption {};
      };

      serif = {
        name = mkOption {};
        package = mkOption {};
      };

      monospace = {
        name = mkOption {};
        package = mkOption {};
      };
    };

    packages = lib.mkOption {
      type = with lib.types; listOf package;
      default = [];
      example = lib.literalExpression "[ pkgs.dejavu_fonts ]";
      description = lib.mdDoc "List of primary font packages.";
    };

    icon = {
      package = mkOption {
        type = with types; nullOr package;
        default = pkgs.papirus-icon-theme;
      };
      name = mkOption {
        type = with types; nullOr package;
        default = "Papirus";
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
          packages = with pkgs;
            cfg.packages
            ++ [
              (nerdfonts.override {fonts = ["NerdFontsSymbolsOnly"];})
            ];
        };

        home-manager.users.${username} = {
          gtk = {
            enable = true;
            font = {
              name = "SF Pro";
              size = 11;
            };
            iconTheme = {
              package = cfg.appearance.icon.package;
              name = cfg.appearance.icon.name;
            };
          };

          programs.dconf.enable = true;
        };
      }
      else {
        fonts.fonts = with pkgs;
          cfg.packages
          ++ [
            (nerdfonts.override {fonts = ["NerdFontsSymbolsOnly"];})
          ];
      }
    )
  ]);
}
