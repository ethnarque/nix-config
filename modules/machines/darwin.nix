{ config, lib, pkgs, system, username, ... }:
let
  inherit (lib)
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
    (if (!builtins.elem system [ "aarch64-darwin" "x86-64-darwin" ])
    then
      { }
    else {
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
