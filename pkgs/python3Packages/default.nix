{
  lib,
  pkgs,
}:
lib.recurseIntoAttrs {
  libgen-api = pkgs.callPackage ./libgen-api.nix { };
  mdformat-obsidian = pkgs.callPackage ./mdformat-obsidian { };
}
