{
  config,
  lib,
  pkgs,
  system,
  username,
  ...
}: let
  cfg = config.apps.ulauncher;
in {
  options.apps.ulauncher = {
    enable = lib.mkEnableOption ''
      uluancher, application launcher for Linux
    '';
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    (
      if !(builtins.elem system ["aarch64-darwin" "x86_64-darwin"])
      then {
        environment.systemPackages = with pkgs; [
          ulauncher
        ];

        systemd.user.services.ulauncher = {
          enable = true;
          description = "Start Ulauncher";
          script = "${pkgs.ulauncher}/bin/ulauncher --hide-window";

          documentation = ["https://github.com/Ulauncher/Ulauncher/blob/f0905b9a9cabb342f9c29d0e9efd3ba4d0fa456e/contrib/systemd/ulauncher.service"];
          wantedBy = ["graphical.target" "multi-user.target"];
          after = ["display-manager.service"];
        };
      }
      else {}
    )
  ]);
}
