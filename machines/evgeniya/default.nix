{ config, lib, pkgs, username, ... }: {
  imports = [
    ./configuration.nix
    ./hardware-configuration.nix
  ];

  machines.linux.enable = true;
  machines.linux.hostName = "evgeniya";
  machines.linux.hardware.intel.enable = true;

  serve.avahi.enable = true;
  serve.printing.enable = true;
  serve.samba.enable = true;
  serve.ssh.enable = true;

  compositors.sway.enable = true;

  # appearances.font.enable = true;

  modules.fonts = {
    enable = true;
    packages = with pkgs; [
      iosevka
      (callPackage ../../packages/apple-fonts.nix { })
    ];
  };

  apps.btop.enable = true;
  apps.firefox = {
    enable = true;
    bookmarks = [
      {
        name = "GitHub - ethnarque";
        tags = [ "ethnarque" "github" ];
        keyword = "github";
        url = "https://github.com/ethnarque";
      }
    ];
  };
  apps.git = {
    enable = true;
    extraConfig = {
      user = {
        email = "42704376+pmlogist@users.noreply.github.com";
        name = "pml";
      };
    };
  };
  modules.gh.enable = true;
  modules.kitty.enable = true;
  modules.mpv.enable = true;
  modules.tmux.enable = true;
  modules.zsh = {
    enable = true;
    plugins = [ ];
  };


  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };



  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?



}

