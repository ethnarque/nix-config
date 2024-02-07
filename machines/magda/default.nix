{ inputs, pkgs, ... }:

{
  imports = with inputs;[
    home-manager.darwinModules.home-manager
    nur.nixosModules.nur
  ];

  machine.darwin.enable = true;
  machine.darwin.touchIdAuth = true;

  machine.darwin.aqua.enable = true;

  machine.darwin.homebrew.taps = [
    "koekeishiya/homebrew-formulae"
    "FelixKratz/homebrew-formulae"
  ];

  machine.darwin.homebrew.brews = [
    "koekeishiya/formulae/yabai"
    "koekeishiya/formulae/skhd"
    "sketchybar"
  ];

  machine.darwin.homebrew.casks = [
    "affinity-photo"
    "alfred"
    "appcleaner"
    "discord"
    "monitorcontrol"
    "mos"
    "radio-silence"
    "the-unarchiver"
    "transmission"
  ];

  machine.hardware.android.enable = true;

  machine.services.ssh.enable = true;
  machine.services.tailscale.enable = true;

  appearance = {
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

  # Apps
  apps.btop.enable = true;

  apps.firefox.enable = true;

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
  apps.mpv.enable = true;
  apps.obinskit.enable = true;
  apps.pass.enable = true;
  apps.zsh.enable = true;
}
