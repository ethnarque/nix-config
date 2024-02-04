{ config, lib, username, ... }:

let
  inherit (lib)
    mkIf
    mkEnableOption;


  cfg = config.apps.gh;
in
{
  options.apps.gh = {
    enable = mkEnableOption "github cli tool";
  };

  config = mkIf cfg.enable {
    hm.programs.gh.enable = true;
  };
}
