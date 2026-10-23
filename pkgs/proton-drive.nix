{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  glib,
  libgcrypt,
  libsecret,
}:

stdenv.mkDerivation rec {
  pname = "proton-drive";
  version = "0.8.0";

  src = fetchurl {
    url = "https://proton.me/download/drive/cli/${version}/linux-x64/proton-drive";
    sha512 = "cf61c2688c45e1055d8add6221d9471a5a5b64bf3bcdb86460f5cb18414596cc4df3cdb6627c9097c94bec32a3c9915ada3211ef2ae5be33c46ebbc996ccaa28";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];
  buildInputs = [
    stdenv.cc.cc.lib
    libsecret
  ];

  dontUnpack = true;

  # strip destroys Bun's embedded JS payload -> binary falls back to Bun CLI
  dontStrip = true;

  installPhase = ''
    install -Dm755 $src $out/bin/proton-drive
    wrapProgram $out/bin/proton-drive \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          glib
          libgcrypt
          libsecret
        ]
      }
  '';

  meta = with lib; {
    description = "Command-line interface for Proton Drive";
    homepage = "https://proton.me/support/drive-cli";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = [ ];
  };
}
