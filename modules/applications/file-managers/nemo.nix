{ config, lib, pkgs, system, username, ... }:
with lib;
let
  cfg = config.modules.file-managers.nemo;
in
{
  options.modules.file-managers.nemo = {
    enable = mkEnableOption "cinnamon nemo file manager";
  };
  config = mkIf cfg.enable (mkMerge [
    (if !(builtins.elem system [ "aarch64-darwin" "x86_64-darwin" ]) then
      {
        environment.systemPackages = with pkgs; [
          cinnamon.nemo-with-extensions
          cinnamon.nemo-fileroller
          unrar
          unzip
          p7zip
        ];

        modules.file-managers.enable = true;

        programs.file-roller.enable = true;
      }
    else
      { })
  ]);
}
