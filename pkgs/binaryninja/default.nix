{ stdenv, glib, libglvnd, xorg, fontconfig, dbus, autoPatchelfHook, requireFile
, unzip, wayland, qt6, zlib, makeDesktopItem, python3, lib, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "binaryninja";
  version = "3.5.5526";
  description = "Binary Ninja: A Reverse Engineering Platform";

  src = requireFile {
    name = "BinaryNinja-personal.zip";
    sha256 = "0rzidb8iyaa9vcc84rgg9455myxwpi0px3sh7zdkiq0vgzysjilc";
    message = ''
      Binary Ninja is commercial software, add BinaryNinja-personal.zip to the nix store with nix-prefetch-url file://$PWD/BinaryNinja-personal.zip
      You can recover this zip file with a licensed email athttps://binary.ninja/recover/
    '';
  };

  unpackPhase = ''
    ${unzip}/bin/unzip $src
  '';

  desktop = makeDesktopItem {
    name = "Binary Ninja Personal";
    exec = "binaryninja";
    icon = pname;
    comment = description;
    desktopName = "Binary Ninja Personal";
    categories = [ "Utility" ];
  };

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/icons
    cp -r binaryninja $out

    ln -s $out/binaryninja/binaryninja $out/bin/binaryninja
    ln -s $out/binaryninja/docs/img/logo.png $out/share/icons/binaryninja.png
    ln -s "$desktop/share/applications" $out/share/
  '';

  postFixup = ''
    wrapProgram $out/bin/binaryninja --prefix LD_LIBRARY_PATH : ${
      lib.makeLibraryPath [ python3 ]
    }
  '';

  dontWrapQtApps = true;

  nativeBuildInputs = [ autoPatchelfHook makeWrapper ];
  buildInputs = [
    stdenv.cc.cc
    glib # libglib-2.0.so.0
    fontconfig # libfontconfig.so.1
    dbus # libdbus-1.so.3
    libglvnd # libGL.so.1
    xorg.libX11 # libX11.so.6
    xorg.libXi # libXi.so.6
    xorg.libXrender # libXrender.so.1
    wayland # libwayland.so.0
    qt6.qtbase # Everything Qt6
    zlib # libz.so.1
    stdenv.cc.cc.lib # libstdc++.so.6
    qt6.qtdeclarative # libQt6Qml.so.6
    qt6.qtwayland # libQt6WaylandClient.so.6
  ];
  runtimeDependencies = [
    python3 # libpython.so
  ];

  meta = {
    homepage = "https://binary.ninja/";
    description = description;
    platforms = [ "x86_64-linux" ];
    maintainers = [ "Thea Heinen <theinen@protonmail.com>" ];
  };
}
