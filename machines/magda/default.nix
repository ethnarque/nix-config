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
    "homebrew/cask-versions"
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
    "iterm2-beta"
    "sublime-text"
    "pokemon-tcg-live"
    "radio-silence"
    "the-unarchiver"
    "transmission"
    "transmission"
  ];

  machine.hardware.android.enable = true;

  machine.services.ssh.enable = true;
  machine.services.tailscale.enable = true;

  appearance = {
    fonts = {
      packages = with pkgs; [
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
      ];

      monospace = {
        name = "Iosevkarque";
        size = 14.0;
      };
    };
  };

  # Apps
  apps.btop.enable = true;
  # apps.emacs.enable = true;
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
  apps.opam.enable = true;
  apps.pass.enable = true;
  apps.zsh.enable = true;
}
