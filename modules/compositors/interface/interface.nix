{ config, lib, options, pkgs, system, username, ... }:
let
  inherit (lib)
    mkIf
    mkEnableOption
    mkMerge
    mkOption
    types;

  cfg = config.compositors.interface;
in
{
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

  config = lib.mkMerge [
    (
      if !(builtins.elem system [ "aarch64-darwin" "x86_64-darwin" ])
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
      else {
        nixpkgs.overlays = [
          (final: prev:
            {
              dark-mode-notify = pkgs.callPackage ../../../packages/dark-mode-notify.nix { };
            })
        ];

        environment.systemPackages = [
          pkgs.dark-mode-notify
        ];

        launchd.user.agents."ke.ethnarque.dark-mode-notify" = {
          serviceConfig = {
            Label = "ke.ethnarque.dark-mode-notify";
            KeepAlive = true;
            StandardErrorPath = "/tmp/dark-mode-notify-stderr.log";
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
                  config.compositors.interface.darkModeScripts
                  config.compositors.interface.lightModeScripts
                ];

                scripts = lib.collect lib.isString
                  (lib.mapAttrs (n: v: "${mkScript n (builtins.elemAt v 0) (builtins.elemAt v 1)}/bin/${n}") apps);
              in
              [
                (lib.mkBefore "${pkgs.dark-mode-notify}/bin/dark-mode-notify")
              ] ++ scripts;
          };
        };
      }
    )
  ];
}
