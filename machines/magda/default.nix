{ inputs, pkgs, username, ... }: {
  modules.kitty = {
    enable = true;
    font.size = 14.0;
  };
  modules.zsh.enable = true;

  machines.darwin.enable = true;

  homebrew.casks = [
    "affinity-photo"
    "discord"
    "radio-silence"
    "transmission"
  ];
}
