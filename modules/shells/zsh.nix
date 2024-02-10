{ config, lib, pkgs, system, username, ... }:

let
  inherit (lib)
    concatLines
    isDarwin
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
      };

      hm = { config, ... }: {
        programs.direnv.enable = true;

        programs.zsh.history = {
          expireDuplicatesFirst = true;
          ignoreAllDups = true;
          path = "${config.xdg.dataHome}/zsh/zsh_history";
        };

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
        };

        programs.zsh.envExtra = concatLines [
          ''
            # brew needs to be evaluated in zshenv in order to have it path added
            ${optionalString (isDarwin system) ''
              if [[ $(uname -m) == 'arm64' ]]; then
                  eval "$(/opt/homebrew/bin/brew shellenv)"
              fi
            ''}
          ''
        ];

        programs.zsh.initExtra = concatLines [
          ''
            source ${pkgs.zsh-history-substring-search}/share/zsh-history-substring-search/zsh-history-substring-search.zsh
            bindkey '^[OA' history-substring-search-up
            bindkey '^[[A' history-substring-search-up
            bindkey '^[OB' history-substring-search-down
            bindkey '^[[B' history-substring-search-down

            ${cfg.initExtra}
          ''
        ];

        programs.zsh.initExtraBeforeCompInit = concatLines [
          ''
            ${optionalString(isDarwin system) ''
                if [[ -d /opt/homebrew/share/zsh/site-functions ]]; then
                  fpath+=/opt/homebrew/share/zsh/site-functions
                fi
              ''}

            ${cfg.initExtraBeforeCompInit}

            autoload -Uz compinit
            if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(N.mh+24) ]]; then
                compinit
            else
                compinit -C
            fi
          ''
        ];

        programs.zsh.loginExtra = concatLines [
          ''
            ${(optionalString (isDarwin system) ''
              ls() {
                  ${pkgs.coreutils}/bin/ls --color=auto "$@"
              }
            '')}
          ''
        ];

        programs.zsh.plugins = [
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

        programs.zsh.sessionVariables = {
          TYPEWRITTEN_PROMPT_LAYOUT = "pure_verbose";
        };

        programs.zsh.shellAliases = {
          "ll" = "ls -la";
          ".." = "cd ..";
        };

        programs.zsh.shellGlobalAliases = {
          "G" = "| grep";
        };
      };
    }
  ]);
}
