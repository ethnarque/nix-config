{ inputs, pkgs, username, ... }: {
  imports = [
    inputs.home-manager.darwinModules.home-manager
  ];

  machines.darwin.enable = true;

  compositors.darwin.aqua.enable = true;
  compositors.appearance = {

    fonts = {
      packages = with pkgs; [
        iosevka
        (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
      ];

      monospace = {
        name = "Iosevka";
        size = 14.0;
      };
    };
  };

  apps = {
    git = {
      enable = true;
      extraConfig = {
        user = {
          email = "42704376+pmlogist@users.noreply.github.com";
          name = "pml";
        };
      };
    };

    gnupg.enable = true;

    kitty = {
      enable = true;
      font.size = 14.0;
      font.name = "Iosevka";
    };

    pass.enable = true;

    zsh.enable = true;
  };

  homebrew = {
    taps = [
      "homebrew/cask-fonts"
    ];
    casks = [
      "affinity-photo"
      "discord"
      "radio-silence"
      "transmission"
    ];
  };
}
