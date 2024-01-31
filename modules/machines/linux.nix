{ config, lib, pkgs, username, system, ... }:

let
  inherit (lib)
    isLinux
    optionalAttrs
    mkIf
    mkEnableOption
    mkMerge
    mkOption
    types;

  cfg = config.machines.linux;
in
{
  options.machines.linux = {
    enable = mkEnableOption ''
      linux system defaults
    '';

    hostName = mkOption {
      type = types.str;
    };
  };

  config = mkIf cfg.enable (mkMerge [
    (optionalAttrs (isLinux system) {
      boot.kernelPackages = pkgs.linuxPackages_latest;

      hardware.enableAllFirmware = true;

      i18n.defaultLocale = "en_US.UTF-8";

      networking.hostName = cfg.hostName;
      networking.firewall.enable = true;

      nix = {
        package = pkgs.nixUnstable;
        extraOptions = ''
          experimental-features = nix-command flakes
        '';
        gc = {
          automatic = true;
          options = "--delete-older-than 30d";
        };
      };

      nixpkgs.config.allowUnfree = true;

      system.stateVersion = "23.05"; # Remember what you read about it!

      users.users."${username}" = {
        isNormalUser = true;
        hashedPassword = "$2b$05$HFTDaVAbnEmFAEmQhw56q.kvUst.Rq6IuG3VjQRIpDdS9kmL8zGFe";
        extraGroups = [ "networkmanager" "video" "wheel" ]; # Enable ‘sudo’ for the user.
        shell = pkgs.zsh;
      };
    })
  ]);
}
