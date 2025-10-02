#!/usr/bin/env bash
# run-with-style.sh (emoji & styled command runner)

set -o errexit
set -o pipefail
set -o nounset

EMOJIS=("🎭" "💀" "🛠️" "⚡" "🔧" "🤖" "📂" "📦" "🚀" "🔐")
FAIL_EMOJIS=("⛔" "❗" "❌")
PREFIX="!___"

COLOR_EM='\033[1;35m'   # magenta for emoji+prefix
COLOR_CMD='\033[1;36m'  # cyan for command
COLOR_OK='\033[1;32m'   # green
COLOR_FAIL='\033[1;31m' # red
COLOR_TS='\033[0;33m'   # yellow timestamp
NC='\033[0m'

CENTER=false
LOG=false
EMOJI=""

usage() {
  echo "Usage: $0 [--center] [--log] [--emoji EMOJI] <command>"
  exit 1
}

# Parse options
while [[ $# -gt 0 && "$1" =~ ^- ]]; do
  case "$1" in
    --center) CENTER=true; shift ;;
    --log) LOG=true; shift ;;
    --emoji) shift; EMOJI="$1"; shift ;;
    --help|-h) usage ;;
    *) break ;;
  esac
done

# If no command given, demo
if [[ $# -eq 0 ]]; then
  CMD_STR='echo "Demo: Hello World!"'
else
  CMD_STR="$*"
fi

# Random emoji if not provided
if [[ -z "$EMOJI" ]]; then
  EMOJI="${EMOJIS[$RANDOM % ${#EMOJIS[@]}]}"
fi

TS="$(date '+%H:%M:%S')"
HEADER="${EMOJI} ${PREFIX} ${CMD_STR}  ·  ${TS}"

# Center header if requested
if $CENTER; then
  WIDTH=$(tput cols 2>/dev/null || echo 80)
  PAD=$(( (WIDTH - ${#HEADER}) / 2 ))
  (( PAD<0 )) && PAD=0
  printf "%*s" "$PAD" ""
fi

# Print the styled header
echo -e "${COLOR_EM}${EMOJI} ${PREFIX}${NC} ${COLOR_CMD}${CMD_STR}${NC} ${COLOR_TS}· ${TS}${NC}"

# Execute command
if $LOG; then
  LOGFILE="$HOME/run-$(date '+%Y%m%d-%H%M%S').log"
  echo "Logging to $LOGFILE"
  bash -c "$CMD_STR" 2>&1 | tee -a "$LOGFILE"
  EXIT_CODE=${PIPESTATUS[0]:-0}
else
  bash -c "$CMD_STR"
  EXIT_CODE=$?
fi

# Show result emoji
if [[ $EXIT_CODE -eq 0 ]]; then
  echo -e "${COLOR_OK}[✓] Command succeeded${NC}"
else
  FAIL_EMOJI="${FAIL_EMOJIS[$RANDOM % ${#FAIL_EMOJIS[@]}]}"
  echo -e "${COLOR_FAIL}${FAIL_EMOJI} Command FAILED with exit code $EXIT_CODE ${FAIL_EMOJI}${NC}"
fi