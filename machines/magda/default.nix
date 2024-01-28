{ inputs, pkgs, username, ... }: {
  machines.darwin.enable = true;

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

    zsh.enable = true;
  };

  homebrew = {
    taps = [
      "homebrew/cask-fonts"
    ];
    casks = [
      "affinity-photo"
      "discord"
      "font-iosevka"
      "font-symbols-only-nerd-font"
      "radio-silence"
      "transmission"
    ];
  };
}
