{ config, lib, pkgs, system, username, ... }:
with lib;
let
  cfg = config.machines.shared;
in
{
  options.machines.shared = {
    enable = mkEnableOption "shared systems defaults";
  };

  config = mkIf cfg.enable (mkMerge [
    # { system.checks.verifyNixPath = false; }

    (if !(builtins.elem systems [ "aarch64-darwin" "x86_64-darwin" ]) then
      {
        nix = {
          package = pkgs.nixUnstable;
          extraOptions = ''
            experimental-features = nix-command flakes
          '';
          gc = {
            automatic = true;
            options = "--delete-older-than 30d";
          };
        };

        nixpkgs.config.allowUnfree = true;
      }
    else
      { })
  ]);
}
