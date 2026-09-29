# `game-art-init`: writes the game-art MCP servers into ./.mcp.json, the
# project-scoped config Claude Code reads, so they load only in the projects
# that want them rather than in every session.
#
# Servers are referenced by command name, not store path: the file is meant to
# be committed, and a store path would break on the next garbage collection or
# on another host. An existing .mcp.json is merged into, never replaced.
{
  writeShellApplication,
  jq,
}:
writeShellApplication {
  name = "game-art-init";
  runtimeInputs = [ jq ];
  text = ''
    all=(aseprite blender playwright)

    usage() {
      echo "usage: game-art-init [--force] [server...]"
      echo
      echo "Adds MCP servers to ./.mcp.json (default: ''${all[*]})."
      echo "Servers already in the file are left alone unless --force is given."
    }

    force=0
    wanted=()
    for arg in "$@"; do
      case "$arg" in
        -h | --help) usage; exit 0 ;;
        -f | --force) force=1 ;;
        aseprite | blender | playwright) wanted+=("$arg") ;;
        *) echo "game-art-init: unknown server '$arg'" >&2; usage >&2; exit 1 ;;
      esac
    done
    [ ''${#wanted[@]} -gt 0 ] || wanted=("''${all[@]}")

    definition() {
      case "$1" in
        aseprite) echo '{"type":"stdio","command":"aseprite-mcp"}' ;;
        blender) echo '{"type":"stdio","command":"mcp-for-blender","env":{"DISABLE_TELEMETRY":"true"}}' ;;
        # Headless so an agent's checks do not open windows over the session.
        playwright) echo '{"type":"stdio","command":"playwright-mcp","args":["--headless"]}' ;;
      esac
    }

    file=.mcp.json
    if [ -e "$file" ]; then
      config=$(jq -e . "$file") || { echo "game-art-init: $file is not valid JSON; not touching it" >&2; exit 1; }
    else
      config='{}'
    fi
    config=$(jq '.mcpServers //= {}' <<< "$config")

    for server in "''${wanted[@]}"; do
      if [ "$force" = 0 ] && jq -e --arg s "$server" '.mcpServers | has($s)' <<< "$config" > /dev/null; then
        echo "kept     $server (already in $file)"
        continue
      fi
      config=$(jq --arg s "$server" --argjson d "$(definition "$server")" '.mcpServers[$s] = $d' <<< "$config")
      echo "added    $server"
    done

    printf '%s\n' "$config" > "$file"
    echo
    echo "Wrote $PWD/$file. Claude Code asks to approve project servers on first use."
    case " ''${wanted[*]} " in
      *" blender "*) echo "The blender server needs a running Blender: start it with 'blender-mcp'." ;;
    esac
  '';

  meta.description = "Write the game-art MCP servers into the current project's .mcp.json";
}
