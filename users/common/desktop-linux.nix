{ pkgs, username, ... }:
{
  home-manager.useGlobalPkgs = true;
  home-manager.extraSpecialArgs = { inherit username; };

}
