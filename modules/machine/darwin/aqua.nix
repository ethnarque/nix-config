{ config, lib, pkgs, system, username, ... }:
let
  inherit (lib)
    isDarwin
    mkEnableOption
    mkIf
    mkOption
    mkMerge
    optionalAttrs
    types;

  inherit (lib.attrsets)
    mergeAttrsList;

  cfg = config.machine.darwin.aqua;
in
{
  options.machine.darwin.aqua = {
    enable = mkEnableOption ''
      minimal defaults for compositors and window managers
    '';

    dock = mkOption {
      type = types.attrs;
      default = { };
    };

    finder = mkOption {
      type = types.attrs;
      default = { };
    };

    keyboard = mkOption {
      type = types.attrs;
      default = { };
    };

    loginwindow = mkOption {
      type = types.attrs;
      default = { };
    };

    NSGlobalDomain = mkOption {
      type = types.attrs;
      default = { };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    (optionalAttrs (isDarwin system) {
      system.defaults.NSGlobalDomain = mergeAttrsList [
        {
          AppleInterfaceStyleSwitchesAutomatically = true;
          AppleShowScrollBars = "WhenScrolling";
          AppleKeyboardUIMode = 3;
          ApplePressAndHoldEnabled = false;
          InitialKeyRepeat = 15;
          KeyRepeat = 5;
          _HIHideMenuBar = true;
          "com.apple.mouse.tapBehavior" = 1;
        }
        cfg.NSGlobalDomain
      ];

      system.defaults.dock = mergeAttrsList [
        {
          autohide = true;
          mineffect = "scale";
          minimize-to-application = true;
          mru-spaces = false;
          show-recents = false;
          wvous-bl-corner = 1;
          wvous-br-corner = 1;
          wvous-tl-corner = 1;
          wvous-tr-corner = 1;
        }
        cfg.dock
      ];


      system.defaults.finder = mergeAttrsList [
        {
          FXDefaultSearchScope = "SCcf";
          FXPreferredViewStyle = "Nlsv";
          ShowPathbar = true;
          ShowStatusBar = true;
        }
        cfg.finder
      ];

      system.defaults.loginwindow = mergeAttrsList [
        {
          GuestEnabled = false;
          autoLoginUser = "${username}";
        }
        cfg.loginwindow
      ];

      system.keyboard = mergeAttrsList [
        {
          enableKeyMapping = true;
          remapCapsLockToControl = true;
        }
        cfg.keyboard
      ];
    })
  ]);
}
