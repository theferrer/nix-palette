# codex-imagegen: a Claude Code plugin that generates and edits images by
# handing the prompt to the Codex CLI, whose built-in gpt-image is billed
# against the ChatGPT plan rather than per image.
#
# Upstream commits its MCP server as a minified esbuild bundle. It is rebuilt
# here from src/, so what runs is what the pinned source says, and the plugin
# becomes a directory marketplace in the store, like pkgs/pixel-plugin. The
# server finds `codex` on PATH; the catalog already has it.
#
# Worth knowing before enabling it: every call runs
# `codex exec --sandbox danger-full-access`, and its skill tells Claude to
# generate images for almost any build task without asking first. That is why
# the palette only ever enables it per project (game-art-init).
#
# The result is at $out/share/claude-plugins/codex-imagegen.
{
  lib,
  stdenvNoCC,
  buildNpmPackage,
  fetchFromGitHub,
  jq,
  nodejs,
}:
let
  src = fetchFromGitHub {
    owner = "colin-automates";
    repo = "Codex-ImageGen--Claude-Code";
    rev = "b01a196b66b0a3a81fbd03c6682bef06155fd869";
    hash = "sha256-8PHJLznEmbiESwZn+agEKoGKEbXV9xSjP7wcOLnAtQc=";
  };

  server = buildNpmPackage {
    pname = "codex-imagegen-server";
    version = "0.1.0";
    inherit src;
    sourceRoot = "${src.name}/plugins/imagegen/server";
    npmDepsHash = "sha256-Kv/qBKTBwi/rto2I500CwxJ/bD1/hqC9MaeNJXqYrOI=";

    # The bundle is self-contained (node builtins only), so node_modules is
    # not shipped.
    installPhase = ''
      runHook preInstall
      install -Dm644 dist/index.cjs $out/index.cjs
      runHook postInstall
    '';
  };
in
stdenvNoCC.mkDerivation {
  pname = "codex-imagegen";
  version = "0.1.0-unstable-2026-04-27";
  inherit src;

  nativeBuildInputs = [ jq ];

  installPhase = ''
    runHook preInstall
    dest=$out/share/claude-plugins/codex-imagegen
    mkdir -p "$dest"
    cp -r . "$dest"

    plugin="$dest/plugins/imagegen"
    rm -rf "$plugin/server"
    install -Dm644 ${server}/index.cjs "$plugin/server/dist/index.cjs"

    # Run the bundle with the store's node instead of whichever is on PATH.
    jq '.mcpServers.imagegen.command = "${lib.getExe nodejs}"' "$plugin/.mcp.json" > mcp.json
    install -m644 mcp.json "$plugin/.mcp.json"
    runHook postInstall
  '';

  passthru = { inherit server; };

  meta = {
    description = "Claude Code plugin generating images through Codex CLI's gpt-image, as a local marketplace";
    homepage = "https://github.com/colin-automates/Codex-ImageGen--Claude-Code";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
}
