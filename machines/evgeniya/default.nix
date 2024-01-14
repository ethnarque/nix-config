{
  config,
  lib,
  pkgs,
  username,
  ...
}: let
  apple-fonts = pkgs.callPackage ../../packages/apple-fonts.nix {};
in {
  imports = [
    ./configuration.nix
    ./hardware-configuration.nix
  ];

  machines.linux.enable = true;
  machines.linux.hostName = "evgeniya";
  machines.linux.hardware.intel.enable = true;

  compositors.gnome.enable = true;
  compositors.interface.fonts = {
    packages = with pkgs; [
      apple-fonts
      iosevka
    ];
    sans = {
      name = "SF Pro";
      size = 11;
    };
    serif = {
      name = "New York Medium";
      size = 11;
    };
    monospace = {
      name = "Iosevka";
      size = 11;
    };
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
