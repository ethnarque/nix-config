{ pkgs, username, ... }:
{
  imports = [
    ../common
  ];

  home-manager.users."${username}" = {
    imports = [
      ../../config/zsh
    ];
  };
}
