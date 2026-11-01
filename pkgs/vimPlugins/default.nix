{
  lib,
  pkgs,
}:
lib.recurseIntoAttrs {
  sops-nvim = pkgs.callPackage ./sops-nvim { };
  typst-infect-nvim = pkgs.callPackage ./typst-infect-nvim { };
  code-runner-nvim = pkgs.callPackage ./code-runer-nvim.nix { };
  overleaf-nvim = pkgs.callPackage ./overleaf-nvim { };
}
