{ config, lib, pkgs, system, username, ... }:
with lib;
let
  cfg = config.serve.printing;
in
{
  options.serve.printing = {
    enable = mkEnableOption "printing capabilities (CUPS)";
  };

  config = mkIf cfg.enable (mkMerge [
    (if !(builtins.elem system [ "aarch64-darwin" "x86_64-darwin" ]) then
      { services.printing.enable = true; }
    else
      { })
  ]);
}
