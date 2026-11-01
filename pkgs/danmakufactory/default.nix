{
  lib,
  stdenv,
  fetchFromGitHub,
  xmake,
  pcre2,
  pins ? builtins.fromJSON (builtins.readFile ./pins.json),
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "danmakufactory";
  inherit (pins) version;
  src = fetchFromGitHub {
    owner = "hihkm";
    repo = "DanmakuFactory";
    inherit (pins) rev hash;
  };

  patches = [ ./use-system-pcre2.patch ];

  nativeBuildInputs = [ xmake ];
  buildInputs = [ pcre2 ];

  configurePhase = ''
    runHook preConfigure

    export HOME="$TMPDIR"
    xmake f -m release -y

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    xmake build -j "$NIX_BUILD_CORES" -v -y

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    xmake install -o "$out" -y
    mv "$out/bin/source" "$out/bin/DanmakuFactory"

    runHook postInstall
  '';

  meta = {
    description = "Convert danmaku files between ASS, XML and JSON formats";
    homepage = "https://github.com/hihkm/DanmakuFactory";
    license = lib.licenses.mit;
    mainProgram = "DanmakuFactory";
    platforms = with lib.platforms; linux ++ darwin;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
  };
})
