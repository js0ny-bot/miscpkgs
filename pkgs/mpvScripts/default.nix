{
  lib,
  pkgs,
}:
lib.recurseIntoAttrs {
  bilibili-sponsorblock = pkgs.callPackage ./bilibili-sponsorblock { };
}
