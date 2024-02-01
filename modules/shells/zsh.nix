{ config, lib, pkgs, system, username, ... }:
let
  inherit (lib)
    isDarwin
    mkAfter
    mkBefore
    mkIf
    mkEnableOption
    mkMerge
    mkOption
    optionalAttrs
    optionalString
    types;

  cfg = config.apps.zsh;
in
{
  options.apps.zsh = {
    enable = mkEnableOption "zsh shell";

    initExtra = mkOption {
      type = types.str;
      default = "";
    };

    initExtraBeforeCompInit = mkOption {
      type = types.str;
      default = "";
    };

    plugins = mkOption {
      type = with types; listOf attrs;
      default = [ ];
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      environment.systemPackages = with pkgs; [
        zsh-history-substring-search # the option does not work for me, needed to load it manually
      ];

      programs.zsh = {
        enable = true;
        enableGlobalCompInit = false; # Already using compinit with home-manager since zsh is managed by it
        promptInit = "";
        interactiveShellInit = "";
      };

      home-manager.users.${username} = { config, ... }: {
        programs.direnv.enable = true;

        programs.zsh = {
          enable = true;
          autocd = false;
          enableCompletion = false;
          defaultKeymap = "viins";

          dirHashes = {
            code = "$HOME/Documents/Code";
            dl = "$HOME/Downloads";
            docs = "$HOME/Documents";
            pics = "$HOME/Pictures";
          };

          dotDir = ".config/zsh";

          history = {
            expireDuplicatesFirst = true;
            ignoreAllDups = true;
            path = "${config.xdg.dataHome}/zsh/zsh_history";
          };

          initExtra = mkMerge [
            (mkBefore (
              ''
                source ${pkgs.zsh-history-substring-search}/share/zsh-history-substring-search/zsh-history-substring-search.zsh
                bindkey '^[OA' history-substring-search-up
                bindkey '^[[A' history-substring-search-up
                bindkey '^[OB' history-substring-search-down
                bindkey '^[[B' history-substring-search-down
              ''
            ))
            (mkAfter cfg.initExtra)
            (optionalString (isDarwin system) ''
              if [[ $(uname -m) == 'arm64' ]]; then
                  eval "$(/opt/homebrew/bin/brew shellenv)"
              fi
            ''
            )
          ];

          initExtraBeforeCompInit = mkMerge [
            (mkBefore (cfg.initExtraBeforeCompInit))
            (optionalString (isDarwin system) ''
              if [[ -d /opt/homebrew/share/zsh/site-functions ]]; then
                  fpath+=/opt/homebrew/share/zsh/site-functions
              fi
            '')
            ''
              autoload -Uz compinit
              if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(N.mh+24) ]]; then
                  compinit
              else
                  compinit -C
              fi
            ''
          ];

          loginExtra = mkMerge [
            (mkIf (isDarwin system)
              ''
                ls() {
                    ${pkgs.coreutils}/bin/ls --color=auto "$@"
                }
              '')
          ];

          plugins = [
            {
              name = "typewritten";
              src = pkgs.fetchFromGitHub {
                owner = "reobin";
                repo = "typewritten";
                rev = "6f78ec20f1a3a5b996716d904ed8c7daf9b76a2a";
                sha256 = "qiC4IbmvpIseSnldt3dhEMsYSILpp7epBTZ53jY18x8=";
              };
            }
            {
              name = "zsh-fast-syntax-highlighting";
              file = "fast-syntax-highlighting.plugin.zsh";
              src = pkgs.fetchFromGitHub {
                owner = "zdharma-continuum";
                repo = "fast-syntax-highlighting";
                rev = "cf318e06a9b7c9f2219d78f41b46fa6e06011fd9";
                sha256 = "RVX9ZSzjBW3LpFs2W86lKI6vtcvDWP6EPxzeTcRZua4=";
              };
            }
          ]
          ++ cfg.plugins;

          sessionVariables = {
            TYPEWRITTEN_PROMPT_LAYOUT = "pure_verbose";
          };

          shellAliases = {
            ll = "ls -la";
            ".." = "cd ..";
          };

          shellGlobalAliases = {
            G = "| grep";
          };
        };
      };
    }

    (optionalAttrs (isDarwin system) {
      nixpkgs.overlays = [
        (final: prev:
          {
            darwin-zsh-completions = pkgs.callPackage ../../packages/darwin-zsh-completions.nix { };
          })
      ];

      environment.systemPackages = [
        pkgs.darwin-zsh-completions
      ];

    })
  ]);
}
