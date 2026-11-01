{
  lib,
  callPackage,
}:
lib.recurseIntoAttrs {
  bilibili-sponsorblock = callPackage ./bilibili-sponsorblock { };
}
