{
  fetchFromGitHub,
  pins ? builtins.fromJSON (builtins.readFile ./pins.json),
  stdenvNoCC,
  lib,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "firefox-csshacks";
  inherit (pins) version;

  src = fetchFromGitHub {
    owner = "MrOtherGuy";
    repo = "firefox-csshacks";
    inherit (pins) rev hash;
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -R . $out/

    runHook postInstall
  '';

  meta = {
    description = "Collection of userstyles affecting the browser";
    homepage = "https://github.com/MrOtherGuy/firefox-csshacks";
    license = lib.licenses.mpl20;
    sourceProvenance = [ lib.sourceProvenance.fromSource ];
  };
})
