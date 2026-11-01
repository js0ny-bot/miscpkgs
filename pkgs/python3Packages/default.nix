{
  lib,
  callPackage,
}:
lib.recurseIntoAttrs {
  libgen-api = callPackage ./libgen-api.nix { };
  mdformat-obsidian = callPackage ./mdformat-obsidian { };
}
