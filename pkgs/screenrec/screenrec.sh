# Toggle a wl-screenrec capture.
#
# Recording is a toggle rather than a hold, so the same keybind can start it
# and stop it. That needs somewhere to remember the capture in flight, and
# $XDG_RUNTIME_DIR is the right somewhere: the kernel clears it on logout, so
# a stale pid can never outlive the session that owns it.

state_dir="${XDG_RUNTIME_DIR:-/tmp}"
pid_file="$state_dir/screenrec.pid"
path_file="$state_dir/screenrec.path"

usage() {
  cat <<'EOF'
usage: screenrec [region|screen|stop] [--audio]

  region   pick an area with slurp and record it (default)
  screen   record the focused monitor
  stop     stop the capture in progress

Invoking screenrec at all while a capture runs stops it, whatever the mode
asked for, so one keybind serves as both start and stop.
EOF
}

notify() {
  notify-send -a screenrec "$@" || true
}

# Prints the pid of the running recorder, or fails if there is none. A pid file
# left behind by a crash points at nothing - or worse, at whatever process got
# that pid next - so confirm it is still our recorder before signalling it.
running_pid() {
  local pid
  [ -r "$pid_file" ] || return 1
  pid=$(cat "$pid_file")
  if [ -z "$pid" ] || [ ! -r "/proc/$pid/comm" ] || [ "$(cat "/proc/$pid/comm")" != wl-screenrec ]; then
    rm -f "$pid_file" "$path_file"
    return 1
  fi
  printf '%s' "$pid"
}

focused_output() {
  [ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ] || return 0
  command -v hyprctl >/dev/null || return 0
  hyprctl -j monitors | jq -r 'map(select(.focused))[0].name // empty'
}

stop() {
  local pid file waited
  if ! pid=$(running_pid); then
    notify "Nothing recording"
    return 0
  fi
  file=$(cat "$path_file" 2>/dev/null || true)

  # SIGINT is the signal wl-screenrec listens for to flush the trailer and
  # close the container. SIGTERM leaves an unplayable file behind.
  kill -INT "$pid"
  waited=0
  while [ -d "/proc/$pid" ] && [ "$waited" -lt 100 ]; do
    sleep 0.1
    waited=$((waited + 1))
  done
  rm -f "$pid_file" "$path_file"

  if [ -n "$file" ] && [ -s "$file" ]; then
    printf '%s' "$file" | wl-copy
    notify "Recording saved" "$file"
  else
    notify -u critical "Recording failed" "Nothing was written"
  fi
}

start() {
  local mode=$1 audio=$2
  local dir file geometry output
  local args=()

  dir="${XDG_RECORDINGS_DIR:-${XDG_VIDEOS_DIR:-$HOME/videos}/recordings}"
  mkdir -p "$dir"
  file="$dir/$(date +%Y-%m-%d-%H%M%S)_screenrec.mp4"
  args+=(--filename "$file")

  case $mode in
    region)
      # slurp exits non-zero when the selection is cancelled with escape. That
      # is a decision, not a failure, so leave without saying anything.
      if ! geometry=$(slurp); then
        exit 0
      fi
      args+=(--geometry "$geometry")
      ;;
    screen)
      # With a single display wl-screenrec picks it on its own, so an empty
      # name is only worth reporting once there is more than one.
      output=$(focused_output)
      if [ -n "$output" ]; then
        args+=(--output "$output")
      fi
      ;;
  esac

  if [ "$audio" = yes ]; then
    args+=(--audio)
  fi

  wl-screenrec "${args[@]}" &
  printf '%s' "$!" >"$pid_file"
  printf '%s' "$file" >"$path_file"
  notify "Recording" "$(basename "$file")"
}

mode=region
audio=no
for arg in "$@"; do
  case $arg in
    region | screen | stop) mode=$arg ;;
    --audio) audio=yes ;;
    -h | --help)
      usage
      exit 0
      ;;
    *)
      usage >&2
      exit 2
      ;;
  esac
done

if running_pid >/dev/null; then
  stop
elif [ "$mode" = stop ]; then
  notify "Nothing recording"
else
  start "$mode" "$audio"
fi
