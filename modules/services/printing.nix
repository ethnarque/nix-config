{
  config,
  lib,
  pkgs,
  system,
  username,
  ...
}:
with lib; let
  cfg = config.services'.printing;
in {
  options.services'.printing = {
    enable = mkEnableOption "printing capabilities (CUPS)";
  };

  config = mkIf cfg.enable (mkMerge [
    (
      if !(builtins.elem system ["aarch64-darwin" "x86_64-darwin"])
      then {services.printing.enable = true;}
      else {}
    )
  ]);
}
