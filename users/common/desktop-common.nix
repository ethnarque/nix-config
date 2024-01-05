{ pkgs, username, ... }: {

  home-manager.users."${username}" = {
    programs.mpv.enable = true;
  };
}
