# pixel-plugin: a Claude Code plugin for Aseprite pixel art -- skills for
# creating, animating, shading and exporting, a few slash commands, and the
# pixel-mcp server they drive.
#
# Upstream ships pixel-mcp as prebuilt binaries behind a `#!/bin/bash`
# launcher, which NixOS does not have: installed as-is, the skills load and
# every tool fails with ENOENT. So pixel-mcp is built from its own source and
# the plugin becomes a local marketplace in the store, with the launcher
# pointing at that build and the vendored binaries dropped.
#
# The result is at $out/share/claude-plugins/pixel-plugin, for a
# `"source": "directory"` marketplace entry.
{
  lib,
  stdenvNoCC,
  buildGoModule,
  fetchFromGitHub,
}:
let
  pixel-mcp = buildGoModule (finalAttrs: {
    pname = "pixel-mcp";
    version = "0.5.0";

    src = fetchFromGitHub {
      owner = "willibrandon";
      repo = "pixel-mcp";
      tag = "v${finalAttrs.version}";
      hash = "sha256-2NCZEfRPTL5pADdeaoYaYH/KgG1HkInTr4gQatN2cEc=";
    };

    vendorHash = "sha256-Ek1LHn4l4QeZMThj2AEznJr5/jYzDd3ogK0L+53tZz4=";
    subPackages = [ "cmd/pixel-mcp" ];
    ldflags = [ "-X main.Version=${finalAttrs.version}" ];

    # The tests drive a real Aseprite through ~/.config/pixel-mcp/config.json.
    doCheck = false;

    meta = {
      description = "MCP server for pixel art in Aseprite";
      homepage = "https://github.com/willibrandon/pixel-mcp";
      license = lib.licenses.mit;
      mainProgram = "pixel-mcp";
    };
  });
in
stdenvNoCC.mkDerivation {
  pname = "pixel-plugin";
  version = "0.5.0-unstable-2025-10-19";

  src = fetchFromGitHub {
    owner = "willibrandon";
    repo = "pixel-plugin";
    rev = "dee350645b705916655c013f208bf5580ecb9317";
    hash = "sha256-zGrDoPHC35mQh12mRLVfUvZfpK1dHFNxFiOIFdg+n+w=";
  };

  installPhase = ''
    runHook preInstall
    dest=$out/share/claude-plugins/pixel-plugin
    mkdir -p "$dest"
    cp -r . "$dest"

    # bin/pixel-mcp is the path the plugin's .mcp.json runs; the rest of bin/
    # is upstream's own CI scripts.
    rm -f "$dest"/bin/pixel-mcp "$dest"/bin/pixel-mcp-*
    ln -s ${lib.getExe pixel-mcp} "$dest"/bin/pixel-mcp
    patchShebangs "$dest"/bin "$dest"/config
    runHook postInstall
  '';

  passthru = { inherit pixel-mcp; };

  meta = {
    description = "Claude Code plugin for Aseprite pixel art, as a local marketplace";
    homepage = "https://github.com/willibrandon/pixel-plugin";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
}
