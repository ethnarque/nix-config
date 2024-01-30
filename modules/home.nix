{ config, lib, pkgs, system, username, ... }:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkMerge;

  cfg = config.home;
in
{
  options.home = { };

  config = mkMerge [
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.${username} = {
        home.stateVersion = "23.11";
      };
    }

    (if (!builtins.elem system [ "aarch64-darwin" "x86-64-darwin" ])
    then
      { }
    else
      { })
  ];
}
