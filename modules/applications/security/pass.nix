{ config
, lib
, pkgs
, system
, username
, ...
}:
with lib; let
  cfg = config.apps.pass;
in
{
  options.apps.pass = {
    enable = mkEnableOption "password-store";
  };

  config = mkIf cfg.enable (mkMerge [
    (
      if !(builtins.elem system [ "aarch64-darwin" "x86_64-darwin" ])
      then {
        home-manager.users.${username} = {
          programs.password-store = {
            enable = true;
            settings = {
              PASSWORD_STORE_CLIP_TIME = "60";
            };
          };
        };
      }
      else { }
    )
  ]);
}
