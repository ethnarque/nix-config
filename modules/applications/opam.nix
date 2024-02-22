{ config, lib, pkgs, username, ... }:
let
  inherit (lib)
    mkIf
    mkEnableOption
    mkMerge;

  cfg = config.apps.opam;
in
{
  options.apps.opam = {
    enable = mkEnableOption "btop";
  };

  config = mkIf cfg.enable {
    hm.programs.opam = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}

