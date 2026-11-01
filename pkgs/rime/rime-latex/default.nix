{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  pins ? builtins.fromJSON (builtins.readFile ./pins.json),
  ...
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "rime-latex";
  inherit (pins) version;

  src = fetchFromGitHub {
    owner = "shenlebantongying";
    repo = "rime_latex";
    inherit (pins) rev hash;
  };

  outputs = [
    "out"
    "raw"
  ];

  postPatch = ''
    find . -name '*.md' -delete
    rm -rf .scripts
    rm -f LICENSE
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $raw $out/share/rime-data
    cp -r . $raw
    cp -r . $out/share/rime-data

    runHook postInstall
  '';

  meta = with lib; {
    description = "Rime input method schema for LaTeX";
    homepage = "https://github.com/shenlebantongying/rime_latex";
    license = licenses.gpl3Only;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
  };
})
