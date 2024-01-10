{
  config,
  lib,
  pkgs, username, ...
}: {
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

  compositors.gnome.enable = true;

  modules.fonts = {
    enable = true;
    packages = with pkgs; [
      iosevka
      (callPackage ../../packages/apple-fonts.nix {})
    ];
  };

  apps.btop.enable = true;

  apps.firefox = {
    enable = true;
    bookmarks = [
      {
        name = "GitHub - ethnarque";
        tags = ["ethnarque" "github"];
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

  apps.gh.enable = true;

  apps.kitty.enable = true;

  apps.mpv.enable = true;

  apps.tmux.enable = true;

  apps.zsh = {
    enable = true;
    plugins = [];
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
}
