{ config, lib, pkgs, system, username, ... }:
let
  cfg = config.compositors.wayland;

  configure-gtk = pkgs.writeTextFile {
    name = "configure-gtk";
    destination = "/bin/configure-gtk";
    executable = true;
    text =
      let
        schema = pkgs.gsettings-desktop-schemas;
        datadir = "${schema}/share/gsettings-schemas/${schema.name}";
      in
      ''
        export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
      '';
  };
in
{
  options.compositors.wayland = {
    enable = lib.mkEnableOption "common wm";
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    (if !(builtins.elem system [ "aarch64-darwin" "x86_64-darwin" ]) then
      {
        environment.sessionVariables.NIXOS_OZONE_WL = "1";
        environment.systemPackages = with pkgs; [
          configure-gtk
          pavucontrol
        ];

        modules.hardware = {
          bluetooth.enable = true;
          sound.enable = true;
        };

        modules.file-managers.nemo.enable = true;

        programs.dconf.enable = true;
        programs.light.enable = true;

        users.users.${username}.extraGroups = [ "video" ];

        xdg.portal = {
          enable = true;
          wlr.enable = true;
        };
      }
    else
      { })
  ]);
}
