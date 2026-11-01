{
  lib,
  pkgs,
}:
lib.recurseIntoAttrs {
  typst-overlay = pkgs.callPackage ./typst-overlay { };
  kitty-graphics = pkgs.callPackage ./kitty-graphics { };
}
