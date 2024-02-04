{ config, lib, pkgs, username, ... }:
let
  inherit (lib)
    mkIf
    mkEnableOption
    mkMerge;

  cfg = config.apps.btop;
in
{
  options.apps.btop = {
    enable = mkEnableOption "btop";
  };

  config = mkIf cfg.enable {
    hm.programs.btop.enable = true;
  };
}

