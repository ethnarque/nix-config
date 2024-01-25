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
    enable = lib.mkEnableOption ''
      interface capabilities for Wayland and X11 compositors
    '';

    darkModeScripts = mkOption {
      type = types.attrs;
    };

    lightModeScripts = mkOption {
      type = types.attrs;
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    (
      if !(builtins.elem system ["aarch64-darwin" "x86_64-darwin"])
      then {
        home-manager.users.${username} = {
          services.darkman = {
            enable = true;

            settings = {
              lat = 45.7;
              lng = 4.9;
              usegeoclue = true;
            };

            darkModeScripts =
              {
                gtk-theme = ''
                  ${pkgs.dconf}/bin/dconf write \
                      /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
                '';

                icon-theme = ''
                  ${pkgs.dconf}/bin/dconf write \
                      /org/gnome/desktop/interface/icon-theme "'Papirus-Dark'"
                '';
              }
              // cfg.darkModeScripts;

            lightModeScripts =
              {
                gtk-theme = ''
                  ${pkgs.dconf}/bin/dconf write \
                      /org/gnome/desktop/interface/color-scheme "'prefer-light'"
                '';

                icon-theme = ''
                  ${pkgs.dconf}/bin/dconf write \
                      /org/gnome/desktop/interface/icon-theme "'Papirus-Light'"
                '';
              }
              // cfg.lightModeScripts;
          };
        };
      }
      else {}
    )
  ]);
}
