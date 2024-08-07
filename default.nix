# This file describes your repository contents.
# It should return a set of nix derivations
# and optionally the special attributes `lib`, `modules` and `overlays`.
# It should NOT import <nixpkgs>. Instead, you should take pkgs as an argument.
# Having pkgs default to <nixpkgs> is fine though, and it lets you use short
# commands such as:
#     nix-build -A mypackage

{ pkgs ? import <nixpkgs> { } }:

rec {
  # The `lib`, `modules`, and `overlays` names are special
  lib = import ./lib { inherit pkgs; }; # functions
  modules = import ./modules; # NixOS modules
  overlays = import ./overlays; # nixpkgs overlays

  binaryninja = pkgs.callPackage ./pkgs/binaryninja { };
  radius2 = pkgs.callPackage ./pkgs/radius2 { };
  pokemon-colorscripts = pkgs.callPackage ./pkgs/pokemon-colorscripts { };
  signal-desktop-twitter = pkgs.callPackage ./pkgs/signal-desktop-twitter { };
  seccomp-tools = pkgs.callPackage ./pkgs/seccomp-tools { };
  vmlinux-to-elf = pkgs.callPackage ./pkgs/vmlinux-to-elf {};
  # some-qt5-package = pkgs.libsForQt5.callPackage ./pkgs/some-qt5-package { };
  # ...
}
