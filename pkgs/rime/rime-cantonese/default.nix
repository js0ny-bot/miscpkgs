{
  stdenvNoCC,
  fetchFromGitHub,
  pins ? builtins.fromJSON (builtins.readFile ./pins.json),
  lib,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "rime-cantonese";
  inherit (pins) version;

  src = fetchFromGitHub {
    owner = "rime";
    repo = "rime-cantonese";
    inherit (pins) rev hash;
  };

  outputs = [
    "out"
    "raw"
  ];

  postPatch = ''
    find . -name '*.md' -delete
    rm -rf .ci .github demo
    rm LICENSE-ODbL LICENSE-CC-BY .gitignore
  '';

  installPhase = ''
    mkdir -p $raw $out/share/rime-data
    cp -r . $raw
    cp -r . $out/share/rime-data
  '';

  meta = {
    description = "Rime Cantonese input schema | 中州韻粵語拼音輸入方案";
    homepage = "https://github.com/rime/rime-cantonese";
    license = with lib.licenses; [
      cc-by-40
      odbl
    ];
    sourceProvenance = [ lib.sourceTypes.fromSource ];
  };
})
