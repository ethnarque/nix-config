{
  config,
  lib,
  pkgs,
  username,
  ...
}:
with lib; let
  cfg = config.appearance.gtk;
in {
  options.appearance.gtk = {
    enable = mkEnableOption "tmux cli";

    font = {
      sans = {
        type = lib.hm.types.fontType;
      };

      serif = {
        type = lib.hm.types.fontType;
      };

      monospace = {
        type = lib.hm.types.fontType;
      };
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

  config = mkIf cfg.enable {
    home-manager.users.${username} = {
      # gtk = {
      #   enable = true;
      #   font = {
      #     name = "SF Pro";
      #     size = 11;
      #   };
      #   iconTheme = {
      #     package = pkgs.papirus-icon-theme;
      #     name = "Papirus";
      #   };
      # };
    };
  };
}
