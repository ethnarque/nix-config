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

  environment.systemPackages = with pkgs; [
    android-tools
    foliate
    tagger
    telegram-desktop
  ];

  machines.linux.enable = true;
  machines.linux.hostName = "evgeniya";
  machines.linux.hardware.intel.enable = true;

  compositors.gnome.enable = true;

  compositors.interface.fonts = {
    packages = with pkgs; [
      apple-fonts
      iosevka
      noto-fonts-cjk
      (nerdfonts.override {fonts = ["NerdFontsSymbolsOnly"];})
    ];
    sans = {
      name = "SF Pro";
      size = 11.0;
    };
    serif = {
      name = "New York Medium";
      size = 11.0;
    };
    monospace = {
      name = "Iosevka";
      size = 11.0;
    };
  };

  compositors.interface.icons = {
    name = "Papirus-Dark";
    package = pkgs.papirus-icon-theme;
  };

  compositors.interface.cursor = {
    name = "Adwaita";
    package = pkgs.gnome.adwaita-icon-theme;
  };

  apps.blackbox-terminal.enable = true;

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

  apps.mpv = {
    enable = true;
    config = {
      gpu-context = "wayland";
    };
  };

  apps.pass.enable = true;

  apps.tmux.enable = true;

  apps.zsh = {
    enable = true;
    plugins = [];
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services'.samba.enable = true;
  services'.ssh.enable = true;
}
