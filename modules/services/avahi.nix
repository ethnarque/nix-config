{ config, lib, pkgs, system, username, ... }:
with lib;
let
  cfg = config.serve.avahi;
in
{
  options.serve.avahi = {
    enable = mkEnableOption "avahi capabilities (CUPS)";
  };

  config = mkIf cfg.enable (mkMerge [
    (if !(builtins.elem system [ "aarch64-darwin" "x86_64-darwin" ]) then
      {
        services.avahi = {
          enable = true;
          nssmdns4 = true;
          publish = {
            enable = true;
            addresses = true;
            domain = true;
            hinfo = true;
            userServices = true;
            workstation = true;
          };
        };
      }
    else
      { })
  ]);
}
