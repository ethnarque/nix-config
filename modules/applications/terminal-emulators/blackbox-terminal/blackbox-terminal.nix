{
  config,
  lib,
  pkgs,
  username,
  ...
}:
with lib; let
  cfg = config.apps.blackbox-terminal;
in {
  options.apps.blackbox-terminal = {
    enable = mkEnableOption "Black Box terminal";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.blackbox-terminal
    ];

    home-manager.users.${username} = let
      fonts = config.compositors.interface.fonts;
    in
      {config, ...}:
        with lib.hm.gvariant; {
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
            terminal-padding = mkTuple [(mkUint32 5) (mkUint32 5) (mkUint32 5) (mkUint32 5)];
            theme-dark = "Ros\233 Pine";
            theme-light = "Ros\233 Pine Dawn";
            was-maximized = false;
          };

          home.file."${config.xdg.dataHome}/blackbox/schemes" = {
            source = ./themes;
            recursive = true;
          };
        };
  };
}
