{ config, lib, pkgs, system, username, ... }:
let
  inherit (lib)
    isLinux
    mkEnableOption
    mkIf
    mkMerge
    optionalAttrs;

  cfg = config.apps.blackbox-terminal;
in
{
  options.apps.blackbox-terminal = {
    enable = mkEnableOption ''
      Black Box terminal
    '';
  };

  config = mkIf cfg.enable (mkMerge [
    (optionalAttrs (isLinux system) {
      environment.systemPackages = [
        pkgs.blackbox-terminal
      ];

      hm =
        let
          fonts = config.appearance.fonts;
        in
        with lib.hm.gvariant;
        { config, ... }: {
          dconf.settings."com/raggesilver/BlackBox" = {
            context-aware-header-bar = true;
            fill-tabs = false;
            floating-controls = false;
            font = "${fonts.monospace.name} ${toString fonts.monospace.size}";
            headerbar-drag-area = false;
            show-headerbar = true;
            show-menu-button = true;
            style-preference = mkUint32 0;
            terminal-bell = false;
            terminal-padding = mkTuple [ (mkUint32 5) (mkUint32 5) (mkUint32 5) (mkUint32 5) ];
            theme-dark = "Rosé Pine";
            theme-light = "Rosé Pine Dawn";
            was-maximized = false;
          };

          home.file."${config.xdg.dataHome}/blackbox/schemes" = {
            source = ./themes;
            recursive = true;
          };
        };

    })

  ]);
}
