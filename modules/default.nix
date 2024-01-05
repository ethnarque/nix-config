{ lib, ... }:
let
  utils = import ../lib { inherit lib; };
  modules = utils.recursiveImports ./.;
in
modules
