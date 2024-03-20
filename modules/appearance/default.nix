{ config, lib, options, pkgs, system, username, ... }:

let
  inherit (lib)
    collect
    flatten
    isDarwin
    isLinux
    isString
    mapAttrs
    mkBefore
    mkIf
    mkEnableOption
    mkMerge
    mkOption
    optionalAttrs
    types;

  cfg = config.appearance;
in
{
  options.appearance = {
    darkModeScripts = mkOption {
      type = types.attrs;
      default = { };
    };

    lightModeScripts = mkOption {
      type = types.attrs;
      default = { };
    };
  };

  config = mkMerge [
    (optionalAttrs (isLinux system) {
      hm.services.darkman = {
        enable = true;

        settings = {
          lat = 45.7;
          lng = 4.9;
          usegeoclue = true;
        };

        darkModeScripts = mkMerge [
          { gtk-theme = '' ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'" ''; }
          { icon-theme = '' ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/interface/icon-theme "'Papirus-Dark'" ''; }
          cfg.darkModeScripts
        ];

        lightModeScripts = mkMerge [
          { gtk-theme = '' ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/interface/color-scheme "'prefer-light'" ''; }
          { icon-theme = '' ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/interface/icon-theme "'Papirus-Light'" ''; }
          cfg.lightModeScripts
        ];
      };

    })

    (optionalAttrs (isDarwin system) {
      #nixpkgs.overlays = [
      #  (final: prev: {
      #    dark-mode-notify = pkgs.callPackage ../../packages/dark-mode-notify.nix { };
      #  })
      #];

      launchd.user.agents."ke.ethnarque.dark-mode-notify" = {
        serviceConfig = {
          Label = "ke.ethnarque.dark-mode-notify";
          KeepAlive = true;
          StandardErrorPath = "/tmp/dark-mode-notify-err.log";
          StandardOutPath = "/tmp/dark-mode-notify-stdout.log";
          ProgramArguments =
            let
              mkScript = name: darkModeScript: lightModeScript: pkgs.writeScriptBin "${toString name}" ''
                #!${pkgs.stdenv.shell}
                if [[ $(defaults read -g AppleInterfaceStyle 2>/dev/null) ]]; then
                    ${darkModeScript}
                else
                    ${lightModeScript}
                fi
              '';

              apps = lib.zipAttrs [
                config.appearance.darkModeScripts
                config.appearance.lightModeScripts
              ];

              scripts = flatten [
                (mkBefore ("${pkgs.dark-mode-notify}/bin/dark-mode-notify"))

                (collect isString
                  (mapAttrs
                    (n: v: "${mkScript n (builtins.elemAt v 0) (builtins.elemAt v 1)}/bin/${n}")
                    apps))
              ];
            in
            scripts;
        };
      };
    })
  ];
}
