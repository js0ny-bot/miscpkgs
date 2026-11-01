{
  lib,
  callPackage,
}:
lib.recurseIntoAttrs {
  dump-tabs = callPackage ./dump-tabs { };
}
