{ lib, stdenv, fetchFromGitHub, rustPlatform, openssl, elfutils, coreutils, bash
, makeBinaryWrapper, pkg-config, xz, fetchCrate, boolector, curl, lingeling
, btor2tools, cmake, glibc }:

rustPlatform.buildRustPackage rec {
  pname = "radius2";
  version = "1.0.26";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-00V9avcMyNjt3Cg02VIPtwOzzafU+MVNBAcSE7XtHOc=";
  };
  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    hash = "sha256-BoHIN/519Top1NUBjpB/oEMqi86Omt3zTQcXFWqrek0=";
  };
  btor2tools-static = (btor2tools.overrideAttrs (old: {
    cmakeFlags = [
      # RPATH of binary /nix/store/.../bin/btorsim contains a forbidden reference to /build/
      "-DBUILD_SHARED_LIBS=OFF"
      "-DCMAKE_SKIP_BUILD_RPATH=ON"
    ];
  }));
  buildInputs = [ openssl xz boolector ];
  nativeBuildInputs = [
    glibc.static
    cmake
    lingeling
    curl
    coreutils
    bash
    pkg-config
    makeBinaryWrapper
  ];
  preBuild = ''
    ls ${btor2tools-static.dev}/include/btor2parser
    mkdir -p /build/${pname}-${version}-vendor.tar.gz/boolector-sys/boolector/deps/install/lib/
    mkdir -p /build/${pname}-${version}-vendor.tar.gz/boolector-sys/boolector/deps/install/include/
    cp ${lingeling.lib}/lib/liblgl.a /build/${pname}-${version}-vendor.tar.gz/boolector-sys/boolector/deps/install/lib/.
    cp ${lingeling.dev}/include/lglib.h /build/${pname}-${version}-vendor.tar.gz/boolector-sys/boolector/deps/install/include/.
    cp ${btor2tools-static.lib}/lib/libbtor2parser.a /build/${pname}-${version}-vendor.tar.gz/boolector-sys/boolector/deps/install/lib/.
    cp ${btor2tools-static.dev}/include/btor2parser/btor2parser.h /build/${pname}-${version}-vendor.tar.gz/boolector-sys/boolector/deps/install/include/.
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp target/x86_64-unknown-linux-gnu/release/radius2 $out/bin/.
  '';

  LIBRARY_PATH = lib.makeLibraryPath ([ glibc.static ]);
  doCheck = false; # there are no tests to run

  cargoSha256 = "sha256-2nV1o86JaCNPayt/Pa+pcMIVkvpfznc1P/5Wlfr8xmc=";

  meta = {
    description =
      "radius2 is a fast binary emulation and symbolic execution framework using radare2";
    homepage = "https://github.com/aemmitt-ns/radius";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
}
