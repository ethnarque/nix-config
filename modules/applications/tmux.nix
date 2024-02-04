{ config, lib, pkgs, username, ... }:

let
  inherit (lib)
    mkEnableOption
    mkIf;

  cfg = config.apps.tmux;
in
{
  options.apps.tmux = {
    enable = mkEnableOption "tmux cli";
  };

  config = mkIf cfg.enable {
    hm.programs.tmux = {
      enable = true;
      baseIndex = 1;
    };
  };
}
