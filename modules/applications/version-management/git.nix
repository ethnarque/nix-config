{ config, lib, pkgs, username, ... }:
with lib;
let
  cfg = config.apps.git;

  # pulled from GitHub
  gitIniType = with types;
    let
      primitiveType = either str (either bool int);
      multipleType = either primitiveType (listOf primitiveType);
      sectionType = attrsOf multipleType;
      supersectionType = attrsOf (either multipleType sectionType);
    in
    attrsOf supersectionType;
in
{
  options.apps.git = {
    enable = mkEnableOption "git cli";

    extraConfig = mkOption {
      type = with types; either lines gitIniType;
      default = { };
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.${username} = {
      programs.git = {
        enable = true;
        delta.enable = true;
        extraConfig = cfg.extraConfig // {
          core = {
            editor = "nvim";
          };
          init = {
            defaultBranch = "main";
          };
          url = {
            "git@github.com:" = {
              insteadOf = "https://github.com/";
            };
          };
        };
      };
    };
  };
}
