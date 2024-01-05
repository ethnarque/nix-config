{ pkgs, username, ... }:
{
  home-manager.useGlobalPkgs = true;
  # home-manager.users."${username}" = {
  # };
  home-manager.extraSpecialArgs = { inherit username; };
}
