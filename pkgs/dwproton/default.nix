{
  stdenvNoCC,
  lib,
  pins ? builtins.fromJSON (builtins.readFile ./pins.json),
}:
let
  makeDWProton =
    {
      pname,
      version,
      src,
    }:
    stdenvNoCC.mkDerivation {
      inherit pname version src;

      installPhase = ''
        runHook preInstall

        mkdir -p $out
        cp -r * $out/
        find $out -xtype l -delete

        runHook postInstall
      '';

      meta = with lib; {
        description = "Proton builds with the latest Dawn Winery fixes.";
        homepage = "https://dawn.wine/dawn-winery/dwproton";
        license = licenses.bsd3;
        platforms = [ "x86_64-linux" ];
        sourceProvenance = [ sourceTypes.binaryBytecode ];
      };
    };
in
let
  dwproton = makeDWProton {
    pname = "dwproton";
    inherit (pins) version;
    src = fetchTarball {
      inherit (pins) url;
      sha256 = pins.hash;
    };
  };
  dwproton-11 =
    let
      version = "11.0-4";
    in
    makeDWProton {
      pname = "dwproton";
      inherit version;
      src = fetchTarball {
        url = "https://dawn.wine/dawn-winery/dwproton/releases/download/dwproton-${version}/dwproton-${version}-x86_64.tar.xz";
        sha256 = "sha256-t5dLTIN+KSCQIG8spzN6soOhfCnnc+OgBoQWBdtJQFM=";
      };
    };
in
{
  inherit dwproton dwproton-11;
  dwproton-pin = dwproton-11;
}
