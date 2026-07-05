{
  lib,
  stdenvNoCC,
  fetchurl,
}:

let
  # Pinned commit of google/fonts, so the fetched files never drift the way the
  # fonts.google.com download endpoint does.
  rev = "5174b3333331c966c38f4355d50b03ca1c1df2f9";
  font =
    {
      name,
      path,
      hash,
    }:
    fetchurl {
      inherit name hash;
      url = "https://raw.githubusercontent.com/google/fonts/${rev}/${path}";
    };

  files = [
    (font {
      name = "Gabarito.ttf";
      path = "ofl/gabarito/Gabarito%5Bwght%5D.ttf";
      hash = "sha256-hlDivXdH99dGGf167LywMJ5vN7eWQCTz+xWuSDO2fKU=";
    })
    (font {
      name = "ReadexPro.ttf";
      path = "ofl/readexpro/ReadexPro%5BHEXP,wght%5D.ttf";
      hash = "sha256-Jou6fh6POxTXmLP7DkDrqj/DkwjJrAAg4vr23xgcww4=";
    })
    (font {
      name = "SpaceGrotesk.ttf";
      path = "ofl/spacegrotesk/SpaceGrotesk%5Bwght%5D.ttf";
      hash = "sha256-rK1t4fyTQ29cDx9BN3Ue8E8a6jBj5wNlNZcP/PvXn3I=";
    })
  ];
in
stdenvNoCC.mkDerivation {
  pname = "quickshell-fonts";
  version = "1.0";

  dontUnpack = true;

  installPhase = ''
    dest=$out/share/fonts/truetype
    for f in ${lib.escapeShellArgs files}; do
      install -m 444 -D "$f" "$dest/''${f##*-}"
    done
  '';

  meta = with lib; {
    description = "Font collection for Quickshell (Gabarito, Readex Pro, Space Grotesk)";
    homepage = "https://fonts.google.com";
    license = licenses.ofl;
    platforms = platforms.all;
  };
}
