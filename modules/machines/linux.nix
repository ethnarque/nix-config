{ config
, lib
, pkgs
, username
, ...
}:
let
  cfg = config.machines.linux;
in
{
  options.machines.linux = with lib; {
    enable = mkEnableOption "linux system defaults";
    hostName = mkOption {
      type = types.str;
    };
  };

  config = with lib;
    mkIf cfg.enable (mkMerge [
      (
        if !(builtins.elem systems [ "aarch64-darwin" "x86_64-darwin" ])
        then {
          boot.kernelPackages = pkgs.linuxPackages_latest;

          hardware.enableAllFirmware = true;

          i18n.defaultLocale = "en_US.UTF-8";

          networking.hostName = cfg.hostName;
          networking.firewall.enable = true;
          # networking.networkmanager.enable = true;
          #
          # networking.networkmanager.wifi.backend = "iwd";
          # networking.wireless.iwd.enable = true;

          users.users."${username}" = {
            isNormalUser = true;
            hashedPassword = "$2b$05$HFTDaVAbnEmFAEmQhw56q.kvUst.Rq6IuG3VjQRIpDdS9kmL8zGFe";
            extraGroups = [ "networkmanager" "video" "wheel" ]; # Enable ‘sudo’ for the user.
            shell = pkgs.zsh;
            packages = with pkgs; [
              wget
              mkpasswd
            ];
          };
        }
        else { }
      )

      { machines.shared.enable = true; }
    ]);
}
