{
  config,
  lib,
  pkgs,
  system,
  username,
  ...
}:
with lib; let
  cfg = config.services'.samba;
in {
  options.services'.samba = {
    enable = mkEnableOption "samba";

    workgroup = mkOption rec {
      type = types.str;
      default = "WORKGROUP";
      description = ''
        Sets the workgroup name.
        Defaults to ${default}
      '';
    };

    shares = mkOption {
      type = types.attrs;
      default = {};
    };
  };

  config = mkIf cfg.enable (mkMerge [
    (
      if !(builtins.elem system ["aarch64-darwin" "x86_64-darwin"])
      then {
        networking.firewall.allowedTCPPorts = [
          137 # Samba: NETBIOS Name Service
          138 # Samba: NETBIOS Datagram Service
          139 # Samba: NETBIOS Session Service
          389 # Samba: for LDAP (Active Directory Mode)
          445 # Samba: NetBIOS was moved to 445 after 2000 and beyond, (CIFS)
          5357 # wsdd
        ];
        networking.firewall.allowedUDPPorts = [
          137 # Samba: NETBIOS Name Service
          138 # Samba: NETBIOS Datagram Service
          139 # Samba: NETBIOS Session Service
          389 # Samba: for LDAP (Active Directory Mode)
          445 # Samba: NetBIOS was moved to 445 after 2000 and beyond, (CIFS)
          3702 # wsdd
        ];

        services.samba = {
          enable = true;
          package = pkgs.samba4;
          # securityType = "user";
          # invalidUsers = [ "root" ];
          # openFirewall = true;
          # extraConfig = ''
          #   server string = smbnix
          #   server role = standalone server
          # '';

          shares =
            cfg.shares
            // {
              public = {
                path = "/home/${toString username}/Public/Shared";
                "guest ok" = "no";
                public = "yes";
                writable = "yes";
                printable = "no";
                browseable = "yes";
                "read only" = "no";
                comment = "Public samba share.";
              };
            };
        };

        services.samba-wsdd = {
          enable = true;
          discovery = true;
          openFirewall = true;
          extraOptions = [
            "--verbose"
          ];
        };
      }
      else {}
    )
  ]);
}
