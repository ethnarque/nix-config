{ lib, ... }: lib.attrsets.mergeAttrsList
  (map
    (x: x { inherit lib; })
    [
      (import ./fs.nix)
      (import ./stdenv.nix)
    ])

