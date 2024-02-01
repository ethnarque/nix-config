{ config, lib, pkgs, system, username, ... }:
let
  inherit (lib)
    isDarwin
    isLinux
    optionalAttrs
    mkEnableOption
    mkIf
    mkMerge;

  cfg = config.services'.tailscale;

  tailscale-darwin = pkgs.stdenv.mkDerivation rec {
    pname = "Tailscale";
    version = "1.58.2";
    nativeBuildInputs = [ pkgs.unzip ];
    sourceRoot = ".";

    installPhase = ''
      mkdir -p "$out/Applications"
      cp -r Tailscale.app "$out/Applications/Tailscale.app"
    '';

    src = pkgs.fetchurl {
      name = "Tailscale-${version}-macos.zip";
      url = "https://pkgs.tailscale.com/stable/Tailscale-${version}-macos.zip";
      sha256 = "zdS4gp1OzWgRhdPrW4D1Xr5BZnKicUIF7DSXkVNV2rY=";
    };
  };
in
{
  options.services'.tailscale = {
    enable = mkEnableOption ''
      tailscale
    '';

  };

  config = mkIf cfg.enable (mkMerge [
    (optionalAttrs (isDarwin system) {
      homebrew.casks = [
        "tailscale"
      ];

      home-manager.users.${username} = {
        programs.zsh.shellAliases = {
          tailscale = "/Applications/Tailscale.app/Contents/MacOS/Tailscale";
        };
      };
    })

    (optionalAttrs (isLinux system) {
      services.tailscale.enable = true;
      networking.firewall = {
        checkReversePath = "loose";
        trustedInterfaces = [ "tailscale0" ];
        allowedUDPPorts = [ config.services.tailscale.port ];
      };
    })
  ]);
}
