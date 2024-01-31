{ config, lib, pkgs, system, username, ... }:
let
  inherit (lib)
    isDarwin
    optionalAttrs
    mkEnableOption
    mkIf
    mkMerge;

  cfg = config.machines.darwin;
in
{
  options.machines.darwin = {
    enable = mkEnableOption "darwin systems defaults";
  };

  config = mkIf cfg.enable (mkMerge [
    (optionalAttrs (isDarwin system) {
      homebrew.enable = true;

      nix.gc.interval = { Weekday = 0; Hour = 0; Minute = 0; };
      nix.settings.trusted-users = [ "@admin" ];

      users.users."${username}" = {
        name = "${username}";
        home = "/Users/${username}";
        isHidden = false;
        shell = pkgs.zsh;
      };

      services.nix-daemon.enable = true;

      security.pam.enableSudoTouchIdAuth = true;

      system.stateVersion = 4;
    })
  ]);
}
