# BBDown/Directory.Build.props: NativeAOT
{
  lib,
  fetchFromGitHub,
  buildDotnetModule,
  clang,
  dotnetCorePackages,
  zlib,
  pins ? builtins.fromJSON (builtins.readFile ./pins.json),
  ...
}:
buildDotnetModule (finalAttrs: {
  pname = "bbdown";
  inherit (pins) version;

  src = fetchFromGitHub {
    owner = "nilaoda";
    repo = "BBDown";
    inherit (pins) rev hash;
  };
  nugetDeps = ./deps.json;

  # Use objcopy provided by llvm
  postPatch = ''
    substituteInPlace BBDown/Directory.Build.props \
      --replace-fail aarch64-linux-gnu-objcopy objcopy
  '';

  nativeBuildInputs = [ clang ];
  buildInputs = [ zlib ];

  projectFile = "BBDown/BBDown.csproj";

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;
  selfContainedBuild = true;

  executables = [ "BBDown" ];

  meta = {
    description = "Command-line downloader for Bilibili videos";
    homepage = "https://github.com/nilaoda/BBDown";
    license = lib.licenses.mit;
    platforms = with lib.platforms; linux ++ darwin;
    mainProgram = "BBDown";
    sourceProvenance = [ lib.sourceTypes.fromSource ];
  };
})
