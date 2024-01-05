{ config, lib, username, ... }:
with lib;
let
  cfg = config.modules.gh;
in
{
  options.modules.gh = {
    enable = mkEnableOption "github cli tool";
  };
  config = mkIf cfg.enable {
    home-manager.users.${username} = {
      programs.gh.enable = true;
    };
  };
}
