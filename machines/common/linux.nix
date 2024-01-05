{ inputs, pkgs, username, ... }:
{
  #users.defaultUserShell = pkgs.zsh;
  users.users."${username}" = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "video" "wheel" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
    packages = with pkgs; [
      wget
      mkpasswd
    ];
  };

  # programs.zsh.enable = true;

  nix = {
    package = pkgs.nixUnstable;
    # settings.trusted-users = [ "@admin" "${username}" ];
    #
    # gc = {
    #   user = "root";
    #   automatic = true;
    #   interval = { Weekday = 0; Hour = 2; Minute = 0; };
    #   options = "--delete-older-than 30d";
    # };

    # Turn this on to make command line easier
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
}
