{ pkgs, ... }: {
  programs.kitty.enable = true;
  programs.kitty.theme = "Rosé Pine";
  programs.kitty.font = {
    name = "Iosevka";
    size = if pkgs.stdenv.isLinux then 11.0 else 14.0;
  };
  programs.kitty.
  settings = {
    enable_audio_bell = false;
    allow_remote_control = true;
    update_check_interval = 0;
    window_padding_width = 12;
    hide_window_decorations = "titlebar-only";
    macos_quit_when_last_window_closed = false;
    macos_option_as_alt = false;
  };
  programs.kitty.shellIntegration.enableZshIntegration = true;
}
