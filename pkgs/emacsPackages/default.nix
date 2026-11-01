{
  lib,
  callPackage,
}:
lib.recurseIntoAttrs {
  typst-overlay = callPackage ./typst-overlay { };
  kitty-graphics = callPackage ./kitty-graphics { };
}
