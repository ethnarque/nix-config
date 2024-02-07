{ config, inputs, lib, pkgs, system, username, ... }:

let
  inherit (lib)
    isDarwin
    optionalAttrs
    mkEnableOption
    mkIf
    mkMerge
    mkOption
    types;

  cfg = config.machine.darwin;
in
{
  options.machine.darwin = {
    enable = mkEnableOption ''
      darwin systems defaults
    '';

    touchIdAuth = mkOption {
      type = types.bool;
      default = false;
    };

    homebrew = {
      brews = mkOption {
        type = with types; listOf str;
        default = [ ];
      };

      casks = mkOption {
        type = with types; listOf str;
        default = [ ];
      };

      taps = mkOption {
        type = with types; listOf str;
        default = [ ];
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    (optionalAttrs (isDarwin system) {
      homebrew.enable = true;

      homebrew.onActivation.cleanup = "zap";

      homebrew.casks = [ ] ++ cfg.homebrew.casks;

      homebrew.taps = [
        "homebrew/cask-fonts"
        "homebrew/services"
      ] ++ cfg.homebrew.taps;

      nix.package = pkgs.nixUnstable;

      nix.settings = {
        experimental-features = [ "nix-command" "flakes" ];
        trusted-users = [ "@admin" "${username}" ];
      };

      nix.gc = {
        user = "root";
        automatic = true;
        interval = { Weekday = 0; Hour = 2; Minute = 0; };
        options = "--delete-older-than 30d";
      };

      nixpkgs.config.allowUnfree = true;

      services.nix-daemon.enable = true;

      security.pam.enableSudoTouchIdAuth = cfg.touchIdAuth;

      system.checks.verifyNixPath = false;
      system.stateVersion = 4;

      users.users."${username}" = {
        name = "${username}";
        home = "/Users/${username}";
        isHidden = false;
        shell = pkgs.zsh;
      };
    })
  ]);
}
