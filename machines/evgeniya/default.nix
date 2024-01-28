{ config, lib, pkgs, username, ... }:
let
  apple-fonts = pkgs.callPackage ../../packages/apple-fonts.nix { };
in
{
  imports = [
    ./configuration.nix
    ./hardware-configuration.nix
  ];

  environment.systemPackages = with pkgs; [
    android-tools
    amberol
    tagger
    foliate
    gimp
    jq
    telegram-desktop
    unrar
    yt-dlp
  ];

  machines.linux = {
    enable = true;
    hostName = "evgeniya";
    hardware.intel.enable = true;
  };

  compositors.gnome.enable = true;

  compositors.interface = {
    fonts = {
      packages = with pkgs; [
        apple-fonts
        noto-fonts-cjk
        noto-fonts-emoji
        iosevka
        (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
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

    icons = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    cursor = {
      name = "Adwaita";
      package = pkgs.gnome.adwaita-icon-theme;
    };
  };

  apps = {
    btop.enable = true;

    firefox = {
      enable = true;
      bookmarks = [
        {
          name = "GitHub - ethnarque";
          tags = [ "ethnarque" "vcs" ];
          keyword = "github";
          url = "https://github.com/ethnarque";
        }
        {
          name = "Codeberg - ethnarque";
          tags = [ "ethnarque" "vcs" ];
          keyword = "codeberg";
          url = "https://codeberg.org/ethnarque";
        }
      ];
      settings = {
        "mousewheel.default.delta_multiplier_y" = 25; # No scroll factor options in gnome
      };
    };

    git = {
      enable = true;
      extraConfig = {
        user = {
          email = "42704376+pmlogist@users.noreply.github.com";
          name = "pml";
        };
      };
    };

    gh.enable = true;

    kitty.enable = true;

    mpv = {
      enable = true;
      config = {
        gpu-context = "wayland";
      };
    };

    obinskit.enable = true;

    pass.enable = true;

    tmux.enable = true;

    zsh.enable = true;
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services' = {
    samba.enable = true;
    ssh.enable = true;
    tailscale.enable = true;
  };
}
