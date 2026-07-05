{
  stdenv,
  lib,
  fetchurl,
  unzip,
}:

stdenv.mkDerivation rec {
  pname = "quickshell-fonts";
  version = "1.0";

  gabarito = fetchurl {
    url = "https://fonts.google.com/download?family=Gabarito";
    sha256 = "1bf2q8fal6hi14gljcwbwnxkg23rrb8li38kcwg96s8xbh62mr9q";
  };

  readexpro = fetchurl {
    url = "https://fonts.google.com/download?family=Readex%20Pro";
    sha256 = "sha256-8fc65Yq2MgfC4jcoccPsVjcHGvWjcFjRvI68rDAImVQ=";
  };

  spacegrotesk = fetchurl {
    url = "https://fonts.google.com/download?family=Space%20Grotesk";
    sha256 = "sha256-k3ta4JBJJ2YwSi7XOJZL6IUwj+cXxe6YCcuM7XPcr1E=";
  };

  nativeBuildInputs = [ unzip ];
  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    mkdir -p $TMPDIR/fonts

    # Extract and install Gabarito
    unzip ${gabarito} -d $TMPDIR/fonts/gabarito || true
    find $TMPDIR/fonts/gabarito -name "*.ttf" -exec cp {} $out/share/fonts/truetype/ \;

    # Extract and install Readex Pro
    unzip ${readexpro} -d $TMPDIR/fonts/readexpro || true
    find $TMPDIR/fonts/readexpro -name "*.ttf" -exec cp {} $out/share/fonts/truetype/ \;

    # Extract and install Space Grotesk
    unzip ${spacegrotesk} -d $TMPDIR/fonts/spacegrotesk || true
    find $TMPDIR/fonts/spacegrotesk -name "*.ttf" -exec cp {} $out/share/fonts/truetype/ \;
  '';

  meta = with lib; {
    description = "Font collection for Quickshell (Gabarito, Readex Pro, Space Grotesk)";
    homepage = "https://fonts.google.com";
    license = licenses.ofl;
    platforms = platforms.all;
  };
}
