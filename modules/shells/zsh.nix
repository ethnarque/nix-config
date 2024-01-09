{ config, lib, pkgs, system, username, ... }:
with lib;
let
  cfg = config.apps.zsh;

  # pulled from GitHub
  # https://github.com/nix-community/home-manager/blob/master/modules/programs/zsh.nix
  pluginModule = types.submodule ({ config, ... }: {
    options = {
      src = mkOption {
        type = types.path;
        description = ''
          Path to the plugin folder.

          Will be added to {env}`fpath` and {env}`PATH`.
        '';
      };

      name = mkOption {
        type = types.str;
        description = ''
          The name of the plugin.

          Don't forget to add {option}`file`
          if the script name does not follow convention.
        '';
      };

      file = mkOption {
        type = types.str;
        description = "The plugin script to source.";
      };
    };

    config.file = mkDefault "${config.name}.plugin.zsh";
  });
in
{
  options.apps.zsh = {
    enable = mkEnableOption "zsh shell";

    plugins = mkOption {
      type = types.listOf pluginModule;
      default = [ ];
      example = literalExpression ''
        [
          {
            # will source zsh-autosuggestions.plugin.zsh
            name = "zsh-autosuggestions";
            src = pkgs.fetchFromGitHub {
              owner = "zsh-users";
              repo = "zsh-autosuggestions";
              rev = "v0.4.0";
              sha256 = "0z6i9wjjklb4lvr7zjhbphibsyx51psv50gm07mbb0kj9058j6kc";
            };
          }
          {
            name = "enhancd";
            file = "init.sh";
            src = pkgs.fetchFromGitHub {
              owner = "b4b4r07";
              repo = "enhancd";
              rev = "v2.2.1";
              sha256 = "0iqa9j09fwm6nj5rpip87x3hnvbbz9w9ajgm6wkrd5fls8fn8i5g";
            };
          }
        ]
      '';
      description = "Plugins to source in {file}`.zshrc`.";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    (if !(builtins.elem system [ "aarch64-darwin" "x86_64-darwin" ]) then
      {
        programs.zsh = {
          enable = true;
          enableGlobalCompInit = false; # Already using compinit with home-manager since zsh is managed by it
          promptInit = "";
          interactiveShellInit = ''
            autoload -Uz compinit
            if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
              compinit
            else
              compinit -C
            fi
          '';
        };
      }
    else
      { })
    # Shared
    {
      home-manager.users.${username} = { config, ... }: {
        home.packages = with pkgs; [
          zsh-history-substring-search # the option does not work for me, needed to load it manually
        ];

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
          history.path = "${config.xdg.dataHome}/zsh/zsh_history";
          initExtraBeforeCompInit = ''
            TYPEWRITTEN_PROMPT_LAYOUT="pure_verbose"

            source ${pkgs.zsh-history-substring-search}/share/zsh-history-substring-search/zsh-history-substring-search.zsh
            bindkey '^[OA' history-substring-search-up
            bindkey '^[[A' history-substring-search-up
            bindkey '^[OB' history-substring-search-down
            bindkey '^[[B' history-substring-search-down
          '';
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
        };
      };
    }
  ]);
}

