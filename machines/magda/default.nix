{ pkgs, ... }:

{
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


  apps.firefox = {
    enable = true;
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

  apps.gnupg.enable = true;
  apps.kitty.enable = true;
  apps.obinskit.enable = true;
  apps.pass.enable = true;
  apps.zsh.enable = true;

  services'.tailscale.enable = true;

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
