{
  lib,
  stdenvNoCC,
  fetchurl,
}:

# Prebuilt release binary (the Go module proxy fetch fails on some networks).
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "gittop";
  version = "0.4.0";

  src = fetchurl {
    url = "https://github.com/hjr265/gittop/releases/download/v${finalAttrs.version}/gittop_${finalAttrs.version}_linux_amd64.tar.gz";
    hash = "sha256-FhGZMxgXh4mGVzEPEYqL00Z7utJ3pb8WlN2jXR5eKDs=";
  };

  sourceRoot = ".";

  installPhase = ''
    mkdir -p $out/bin
    install -m755 gittop $out/bin/gittop
  '';

  meta = with lib; {
    description = "Interactive Git repository browser";
    homepage = "https://github.com/hjr265/gittop";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "gittop";
  };
})
