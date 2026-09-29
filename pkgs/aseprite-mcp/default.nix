# Aseprite MCP: an MCP server giving an agent Aseprite's drawing, layers,
# animation, palette and export operations, plus onion-skin renders and frame
# diffs to check its own animation work. Every tool call runs Aseprite in batch
# mode (`aseprite -b --script`), so no GUI has to be open.
#
# Upstream is run from a checkout with `uv run -m aseprite_mcp` and declares no
# build backend or entry point, so the package is its module plus a Python
# with the dependencies, and a wrapper that runs it.
{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  makeWrapper,
  python3,
  aseprite,
}:
let
  python = python3.withPackages (
    ps: with ps; [
      mcp
      httpx
      pillow
      # imported by core/commands.py but missing from pyproject.toml
      python-dotenv
    ]
  );
in
stdenvNoCC.mkDerivation {
  pname = "aseprite-mcp";
  version = "0.1.0-unstable-2026-07-29";

  src = fetchFromGitHub {
    owner = "diivi";
    repo = "aseprite-mcp";
    rev = "90d1696a7e41edff89bbd0823ae6a5f86c114bcc";
    hash = "sha256-BnLBEhc5IpTh6ph5l4g0qgTN5KRS0Xf0pEcnox0EWjA=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/aseprite-mcp
    cp -r aseprite_mcp $out/share/aseprite-mcp/

    # ASEPRITE_PATH is only a default: point it elsewhere to try another build.
    makeWrapper ${python.interpreter} $out/bin/aseprite-mcp \
      --add-flags "-m aseprite_mcp" \
      --prefix PYTHONPATH : $out/share/aseprite-mcp \
      --set-default ASEPRITE_PATH ${lib.getExe aseprite}
    runHook postInstall
  '';

  meta = {
    description = "MCP server for creating and animating pixel art in Aseprite";
    homepage = "https://github.com/diivi/aseprite-mcp";
    license = lib.licenses.mit;
    mainProgram = "aseprite-mcp";
  };
}
