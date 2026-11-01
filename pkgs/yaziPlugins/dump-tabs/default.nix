{
  pkgs,
  lib,
  fetchFromGitHub,
  pins ? builtins.fromJSON (builtins.readFile ./pins.json),
  ...
}:
pkgs.stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "dump-tabs";
  inherit (pins) version;
  src = fetchFromGitHub {
    owner = "js0ny";
    repo = "dump-tabs.yazi";
    inherit (pins) rev hash;
  };
  installPhase = ''
    runHook preInstall
    cp -r . $out
    runHook postInstall
  '';
  meta = {
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
  };
})
