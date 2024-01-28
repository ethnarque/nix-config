{ config
, lib
, pkgs
, username
, ...
}:
let
  modules = import ../../modules { inherit lib; };
in
{
  imports = modules;

  home-manager.users."${username}" = {
    programs.bat.enable = true;

    home.packages = with pkgs; [
    ];

    home.stateVersion = "23.11";
  };
}
