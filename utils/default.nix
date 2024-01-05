{ pkgs, lib }: rec{
  getDir =
    dir:
    builtins.mapAttrs
      (file: type: if type == "directory" then getDir "${dir}/${file}" else type)
      (builtins.readDir dir);

  files =
    dir:
    lib.collect
      builtins.isString
      (lib.mapAttrsRecursive
        (path: type: builtins.concatStringsSep "/" path)
        (getDir dir));

  importAllFrom =
    dir:
    map
      (file: ./. + "/${file}")
      (pkgs.lib.filter
        (file: pkgs.lib.hasSuffix ".nix" file && file != "default.nix")
        (files dir)
      );


  recursiveImports = dir:
    let
      # Recursively constructs an attrset of a given folder, recursing on
      # directories, value of attrs is the filetype
      getDir = dir:
        lib.mapAttrs
          (
            file: type:
              if type == "directory"
              then getDir "${dir}/${file}"
              else type
          )
          (builtins.readDir dir);

      # Collects all files of a directory as a list of strings of paths
      files = path:
        if lib.pathType path == "directory"
        then
          lib.collect lib.isString
            (lib.mapAttrsRecursive
              (path: _type: lib.concatStringsSep "/" path)
              (getDir path))
        else [ path ];

      # Filters out files that don't end with .nix and also make the strings absolute path based
      validFiles = path:
        map
          (file:
            if lib.hasPrefix "/nix/store" file
            then file
            else path + "/${file}")
          # (lib.filter
          # (lib.hasSuffix ".nix")
          (lib.filter
            (file: pkgs.lib.hasSuffix ".nix" file && file != "default.nix")
            (files dir)
          );
    in
    validFiles dir;
}
