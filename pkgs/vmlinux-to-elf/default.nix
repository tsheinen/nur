{ lib, python3Packages, fetchFromGitHub }:
with python3Packages;
buildPythonApplication {
  pname = "vmlinux-to-elf";
  version = "1.0";

  propagatedBuildInputs = [ pip python-lzo lz4 zstandard ];

  src = fetchFromGitHub {
    owner = "marin-m";
    repo = "vmlinux-to-elf";
    rev = "fa5c930";
    sha256 = "sha256-/q4pZAam96OL6rMDGJcxBGD02Oo8rDpKoOcnydFUioo=";
  };
}
