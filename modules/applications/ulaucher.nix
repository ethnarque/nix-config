{ config, lib, pkgs, system, username, ... }:
let
  inherit (lib)
    isLinux
    optionalAttrs
    mkEnableOption
    mkIf
    mkMerge;

  cfg = config.apps.ulauncher;
in
{
  options.apps.ulauncher = {
    enable = mkEnableOption ''
      uluancher, application launcher for Linux
    '';
  };

  config = mkIf cfg.enable (mkMerge [
    (optionalAttrs (isLinux system) {
      environment.systemPackages = with pkgs; [
        ulauncher
      ];

      systemd.user.services.ulauncher = {
        enable = true;
        description = "Start Ulauncher";
        script = "${pkgs.ulauncher}/bin/ulauncher --hide-window";

        documentation = [ "https://github.com/Ulauncher/Ulauncher/blob/f0905b9a9cabb342f9c29d0e9efd3ba4d0fa456e/contrib/systemd/ulauncher.service" ];
        wantedBy = [ "graphical.target" "multi-user.target" ];
        after = [ "display-manager.service" ];
      };
    })
  ]);
}
