{
  lib,
  pkgs,
}:
lib.recurseIntoAttrs {
  dump-tabs = pkgs.callPackage ./dump-tabs { };
}
