{ pkgs, fetchzip, asar }:
pkgs.signal-desktop.overrideAttrs (old: {
  twemoji = fetchzip {
    url =
      "https://registry.npmjs.org/emoji-datasource-twitter/-/emoji-datasource-twitter-15.0.1.tgz";
    sha256 = "sha256-HFZPWyM2LqSrvc+QDj7JNdBdic5v3yfRZcTSwgQXqkI=";
  };
  preInstall = ''
    ${asar}/bin/asar extract opt/Signal/resources/app.asar opt/Signal/resources/app.asar.tmp
    mkdir -p opt/Signal/resources/app.asar.unpacked/node_modules/emoji-datasource-apple/img/apple/64/
    cp -r $twemoji/img/twitter/64/ opt/Signal/resources/app.asar.tmp/node_modules/emoji-datasource-apple/img/apple/.
    rm -f opt/Signal/resources/app.asar
    ${asar}/bin/asar pack opt/Signal/resources/app.asar.tmp opt/Signal/resources/app.asar
  '';
})
