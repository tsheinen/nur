{ lib
, stdenv
, coreutils
, fetchFromGitLab
}:

stdenv.mkDerivation rec {
  pname = "pokemon-colorscripts";
  version = "main";

  src = fetchFromGitLab {
    owner = "phoneybadger";
    repo = "${pname}";
    rev = "0483c85b93362637bdd0632056ff986c07f30868";
    sha256 = "sha256-rj0qKYHCu9SyNsj1PZn1g7arjcHuIDGHwubZg/yJt7A=";
  };

  buildInputs = [ coreutils ];

  preBuild = ''
    patchShebangs ./install.sh

    # Fix hardcoded prefixed coreutils
    #substituteInPlace pokemon-colorscripts.sh --replace greadlink readlink
    #substituteInPlace pokemon-colorscripts.sh --replace gshuf shuf

    substituteInPlace install.sh --replace /usr/local $out
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt
    mkdir -p $out/bin
    ./install.sh

    runHook postInstall
  '';

}
