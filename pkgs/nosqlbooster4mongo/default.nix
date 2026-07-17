{
  pkgs,
  appimageTools,
  lib,
  ...
}:
let
  pname = "nosqlbooster4mongo";
  version = "11.0.5";
  # Upstream added an arch suffix and only keeps the latest patch published; the
  # old releasesv10/...-10.0.0.AppImage URL now 404s. Filename is now -x64.
  src = pkgs.fetchurl {
    url = "https://s3.nosqlbooster.com/download/releasesv${lib.versions.major version}/nosqlbooster4mongo-${version}-x64.AppImage";
    hash = "sha256-OOIA95CZugtOIjV45QeKcZ4NbG9JZh7DAR61gFnxFlE=";
  };
  meta = {
    homepage = "https://nosqlbooster.com/";
    description = "GUI tool for MongoDB Server";
    changelog = "https://nosqlbooster.com/blog/announcing-nosqlbooster-10";
    maintainers = with lib.maintainers; [ guillaumematheron ];
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    mainProgram = "nosqlbooster4mongo";
  };

  appimageContents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit
    pname
    src
    version
    meta
    ;

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/nosqlbooster4mongo.desktop $out/share/applications/nosqlbooster4mongo.desktop
    install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/512x512/apps/nosqlbooster4mongo.png \
      $out/share/icons/hicolor/512x512/apps/nosqlbooster4mongo.png
    substituteInPlace $out/share/applications/nosqlbooster4mongo.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=${meta.mainProgram}'
  '';
}
