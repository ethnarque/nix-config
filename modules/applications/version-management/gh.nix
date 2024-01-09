{ config, lib, username, ... }:
with lib;
let
  cfg = config.apps.gh;
in
{
  options.apps.gh = {
    enable = mkEnableOption "github cli tool";
  };
  config = mkIf cfg.enable {
    home-manager.users.${username} = {
      programs.gh.enable = true;
    };
  };
}
