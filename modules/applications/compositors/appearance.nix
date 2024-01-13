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
  cfg = config.compositors.appearance;
in {
  options.compositors.appearance = {
    enable = lib.mkEnableOption "kitty terminal";

    fonts = {
      packages = mkOption {
        type = with types; listOf package;
        default = [];
      };
    };

    font = {
      packages = lib.mkOption {
        type = with lib.types; listOf package;
        default = [];
      };

      sans = {
        name = mkOption {
          type = types.str;
          default = "SF Pro";
        };
        size = mkOption {
          type = types.number;
          default = 11;
        };
        package = mkOption {};
      };

      serif = {
        name = mkOption {
          type = types.str;
          default = "SF Pro";
        };
        package = mkOption {};
      };

      monospace = {
        name = mkOption {};
        package = mkOption {};
      };
    };

    icon = {
      package = mkOption {
        type = with types; nullOr package;
        default = pkgs.papirus-icon-theme;
      };
      name = mkOption {
        type = types.str;
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
              name = cfg.font.sans.name;
              size = cfg.font.sans.size;
            };
            iconTheme = {
              package = cfg.icon.package;
              name = cfg.icon.name;
            };
          };

          # dconf.settings = {
          #   "org.gnome.desktop.interface" = {
          #     document-font-name = let f = cfg.font.serif; in "${f.name} ${toString f.size}";
          #     monospace-font-name = let f = cfg.font.monospace; in "${f.name} ${toString f.size}";
          #   };
          # };
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
