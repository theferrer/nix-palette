# MCP for Blender (formerly blender-mcp): an MCP server that drives a running
# Blender through a socket its add-on opens. Two commands:
#
#   mcp-for-blender   the MCP server, for an agent's MCP config
#   blender-mcp       Blender with the add-on loaded; its server starts itself
#
# The add-on is loaded per launch from the store (`--addons`), instead of being
# installed into ~/.config/blender, so the add-on and the server always come
# from the same pin -- they speak a versioned protocol and refuse a mismatch.
{
  lib,
  python3Packages,
  fetchFromGitHub,
  makeWrapper,
  blender,
}:
python3Packages.buildPythonApplication {
  pname = "mcp-for-blender";
  version = "2.1.1-unstable-2026-09-27";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ahujasid";
    repo = "mcp-for-blender";
    rev = "41a184322db3ccdcb2fdbc1f6994afe71bf9163c";
    hash = "sha256-/eku9RX6+2OwdVOaE3P6LlbiBSV2uexh449lmfNor38=";
  };

  build-system = [ python3Packages.setuptools ];
  dependencies = with python3Packages; [
    mcp
    httpx
  ];
  nativeBuildInputs = [ makeWrapper ];

  # Upstream counts every tool call by default; DISABLE_TELEMETRY is the switch
  # its README documents for turning that off entirely.
  #
  # BLENDER_SYSTEM_SCRIPTS adds a script directory alongside the user's own,
  # and --addons enables the add-on for this session only, so neither the
  # user's preferences nor a plain `blender` are touched.
  postFixup = ''
    wrapProgram $out/bin/mcp-for-blender --set-default DISABLE_TELEMETRY true

    install -Dm644 src/blender_mcp/bundled/addon.py \
      $out/share/blender/scripts/addons/blender_mcp_addon.py
    makeWrapper ${lib.getExe blender} $out/bin/blender-mcp \
      --set BLENDER_SYSTEM_SCRIPTS $out/share/blender/scripts \
      --add-flags "--addons blender_mcp_addon"
  '';

  pythonImportsCheck = [ "blender_mcp.server" ];

  meta = {
    description = "MCP server that lets an LLM drive Blender, plus a Blender launcher with its add-on";
    homepage = "https://github.com/ahujasid/mcp-for-blender";
    license = lib.licenses.mit;
    mainProgram = "mcp-for-blender";
  };
}
