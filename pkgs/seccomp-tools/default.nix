{ lib, binutils, bundlerApp, bundlerUpdateScript, makeWrapper }:

bundlerApp {
  pname = "seccomp-tools";
  gemdir = ./.;
  exes = [ "seccomp-tools" ];

  nativeBuildInputs = [ makeWrapper ];

  postBuild = ''
    # wrapProgram $out/bin/seccomp-tools --prefix PATH : ${binutils}/bin
  '';

  passthru.updateScript = bundlerUpdateScript "seccomp-tools";

  meta = with lib; {
    description = " Provide powerful tools for seccomp analysis";
    homepage    = "https://github.com/david942j/seccomp-tools";
    license     = licenses.mit;
    platforms   = platforms.unix;
  };
}