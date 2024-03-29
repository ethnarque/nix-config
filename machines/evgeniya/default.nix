{ config, inputs, lib, pkgs, username, ... }:
let
  apple-fonts = pkgs.callPackage ../../packages/apple-fonts.nix { };
in
{
  imports = with inputs;[
    ./hardware-configuration.nix
    ./configuration.nix
    nixos-hardware.nixosModules.lenovo-thinkpad-t480
    home-manager.nixosModules.home-manager
    nur.nixosModules.nur
  ];

  environment.systemPackages = with pkgs; [
    amberol
    tagger
    foliate
    gimp
    jq
    telegram-desktop
    unrar
    yt-dlp
  ];


  machine.linux.enable = true;
  machine.linux.hostName = "evgeniya";

  machine.linux.gnome.enable = true;

  machine.hardware.intel.enable = true;
  machine.hardware.sound.enable = true;
  machine.hardware.bluetooth.enable = true;
  machine.hardware.android.enable = true;

  machine.services.avahi.enable = true;
  machine.services.printing.enable = true;
  machine.services.samba.enable = true;
  machine.services.ssh.enable = true;
  machine.services.tailscale.enable = true;

  apps.valent.enable = true;
  apps.ulauncher.enable = true;

  appearance.fonts = {
    packages = with pkgs; [
      apple-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      (iosevka.override {
        set = "custom";
        privateBuildPlan = {
          family = "Iosevkarque";
          spacing = "fontconfig-mono";
          serifs = "sans";
          noCvSs = true;
          exportGlyphNames = true;
          noLigation = true;

          variants.inherits = "ss15";

          weights.Light = {
            shape = 300;
            menu = 300;
            css = 300;
          };

          weights.Regular = {
            shape = 400;
            menu = 400;
            css = 400;
          };

          weights.Bold = {
            shape = 700;
            menu = 700;
            css = 700;
          };
          # ligations.inherits = "dlig";
        };
      })
      (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
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
      name = "Iosevkarque";
      size = 11.0;
    };
  };


  appearance = {
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

    gnupg.enable = true;

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

}
