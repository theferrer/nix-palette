# `game-art-init`: sets up the current project for the game-art tools:
#
#   .mcp.json              the aseprite, blender and playwright MCP servers
#   .claude/settings.json  enables pixel-plugin (its marketplace is registered
#                          for every session by the palette's pixel-plugin app)
#
# Project-scoped, so none of it loads in sessions that have nothing to do with
# art. Servers are referenced by command name, not store path: the files are
# meant to be committed, and a store path would break on the next garbage
# collection or on another host. Existing files are merged into, never
# replaced.
{
  writeShellApplication,
  jq,
}:
writeShellApplication {
  name = "game-art-init";
  runtimeInputs = [ jq ];
  text = ''
    all=(aseprite blender playwright pixel)

    usage() {
      echo "usage: game-art-init [--force] [aseprite|blender|playwright|pixel]..."
      echo
      echo "Sets up this project (default: ''${all[*]}):"
      echo "  aseprite, blender, playwright  MCP servers, in ./.mcp.json"
      echo "  pixel                          pixel-plugin, enabled in ./.claude/settings.json"
      echo "Entries already present are left alone unless --force is given."
    }

    force=0
    wanted=()
    for arg in "$@"; do
      case "$arg" in
        -h | --help) usage; exit 0 ;;
        -f | --force) force=1 ;;
        aseprite | blender | playwright | pixel) wanted+=("$arg") ;;
        *) echo "game-art-init: unknown item '$arg'" >&2; usage >&2; exit 1 ;;
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

    # load FILE: prints its JSON, or {} when it does not exist yet.
    load() {
      if [ -e "$1" ]; then
        jq -e . "$1" || { echo "game-art-init: $1 is not valid JSON; not touching it" >&2; exit 1; }
      else
        echo '{}'
      fi
    }

    # set_entry JSON PATH VALUE LABEL FILE: prints JSON with PATH set to VALUE,
    # unless PATH is already set and --force was not given.
    set_entry() {
      local config=$1 path=$2 value=$3 label=$4 file=$5
      if [ "$force" = 0 ] && jq -e "$path != null" <<< "$config" > /dev/null; then
        echo "kept     $label (already in $file)" >&2
      else
        config=$(jq --argjson v "$value" "$path = \$v" <<< "$config")
        echo "added    $label" >&2
      fi
      printf '%s\n' "$config"
    }

    mcp=.mcp.json
    settings=.claude/settings.json
    mcp_config=""
    settings_config=""

    # Both files are loaded before anything is written, so one that is not
    # valid JSON stops the run with neither touched.
    case " ''${wanted[*]} " in
      *" aseprite "* | *" blender "* | *" playwright "*) mcp_config=$(load "$mcp") || exit 1 ;;
    esac
    case " ''${wanted[*]} " in
      *" pixel "*) settings_config=$(load "$settings") || exit 1 ;;
    esac

    for item in "''${wanted[@]}"; do
      case "$item" in
        pixel)
          settings_config=$(set_entry "$settings_config" '.enabledPlugins["pixel-plugin@pixel-plugin"]' true "pixel-plugin" "$settings")
          ;;
        *)
          mcp_config=$(set_entry "$mcp_config" ".mcpServers[\"$item\"]" "$(definition "$item")" "$item" "$mcp")
          ;;
      esac
    done

    echo
    if [ -n "$mcp_config" ]; then
      printf '%s\n' "$mcp_config" > "$mcp"
      echo "Wrote $PWD/$mcp. Claude Code asks to approve project servers on first use."
    fi
    if [ -n "$settings_config" ]; then
      mkdir -p .claude
      printf '%s\n' "$settings_config" > "$settings"
      echo "Wrote $PWD/$settings."
    fi
    case " ''${wanted[*]} " in
      *" blender "*) echo "The blender server needs a running Blender: start it with 'blender-mcp'." ;;
    esac
  '';

  meta.description = "Set up the current project's MCP servers and pixel-plugin for the game-art tools";
}
