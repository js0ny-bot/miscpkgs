{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPnpmDeps,

  # build tools
  makeWrapper,
  nodejs_24,
  pnpm_10,
  pnpmConfigHook,

  pins ? builtins.fromJSON (builtins.readFile ./pins.json),
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "noname";
  inherit (pins) version;
  src = fetchFromGitHub {
    owner = "libnoname";
    repo = "noname";
    inherit (pins) rev hash;
  };

  pnpmRoot = ".";

  nativeBuildInputs = [
    nodejs_24
    pnpm_10
    pnpmConfigHook
    makeWrapper
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      pnpmRoot
      ;
    pnpm = pnpm_10;
    fetcherVersion = 3;
    hash = pins.pnpmHash;
  };

  pnpmInstallFlags = [ "--frozen-lockfile" ];

  buildPhase = ''
    runHook preBuild

    cd ${finalAttrs.pnpmRoot}
    pnpm build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/noname
    cp -r ./* $out/share/noname

    mkdir -p $out/bin

    makeWrapper ${lib.getExe nodejs_24} $out/bin/noname-server \
            --add-flags "$out/share/noname/packages/fs/dist/entry.cjs" \
            --add-flags "--server" \
            --add-flags "--dirname=$out/share/noname/dist"

    runHook postInstall
  '';

  meta = {
    description = "无名杀 noname (libnoname/noname)";
    homepage = "https://github.com/libnoname/noname";
    license = lib.licenses.gpl3Only;
    platforms = with lib.platforms; linux ++ darwin;
    mainProgram = "noname-server";
    sourceProvenance = [ lib.sourceTypes.fromSource ];
  };
})
