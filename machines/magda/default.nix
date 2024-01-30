{ inputs, pkgs, username, ... }: {
  imports = [
    inputs.home-manager.darwinModules.home-manager
  ];

  machines.darwin.enable = true;

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

  programs.gnupg.agent.enable = true;

  environment.systemPackages = with pkgs;[
    gnupg
  ];

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
