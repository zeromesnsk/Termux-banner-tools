#!/usr/bin/env bash
# run-with-style-pro.sh
# Professional "hacker-style" command runner for Termux/Linux
# Features:
#   - ASCII banner (figlet + lolcat) with selectable style
#   - Centered, colorized header box with emoji, prefix, command, timestamp, email
#   - Custom emoji or random emoji per run
#   - Custom ASCII-art file support
#   - --center, --log, --emoji, --style, --email, --ascii flags
#   - Nice success/failure messages with random failure emoji (⛔/❗/❌)
#
# Usage examples:
#   ./run-with-style-pro.sh ls -la
#   ./run-with-style-pro.sh --center --log --emoji "🔐" --style block --email you@host git status
#   ./run-with-style-pro.sh --ascii ~/logo.txt echo "done"

set -o pipefail
# don't set errexit so we can capture command exit code and show emojis
# set -o errexit
set -o nounset

# ----------------------------
# Configuration / Defaults
# ----------------------------
EMOJI_POOL=("🎭" "💀" "🛠️" "⚡" "🔧" "🤖" "📂" "📦" "🚀" "🔐" "🛰️" "📡")
FAIL_EMOJIS=("⛔" "❗" "❌")
PREFIX="!___"

# Colors (ANSI)
COLOR_EM='\033[1;35m'    # magenta (emoji+prefix)
COLOR_CMD='\033[1;36m'   # cyan (command)
COLOR_OK='\033[1;32m'    # green success
COLOR_FAIL='\033[1;31m'  # red fail
COLOR_TS='\033[0;33m'    # yellow timestamp
COLOR_BOX='\033[1;34m'   # blue box
COLOR_BANNER='\033[1;33m' # banner color fallback
NC='\033[0m'

# Defaults you can override with flags
CENTER=false
LOG=false
EMOJI=""
BANNER_STYLE="slant"    # figlet font: standard, slant, block, digital, script, small, big, etc.
HACKER_EMAIL="hacker@localhost"
ASCII_FILE=""

# ----------------------------
# Helpers
# ----------------------------
usage() {
  cat <<EOF
Usage: $0 [options] -- <command>...
Options:
  --center            Center header & banner
  --log               Save command output to \$HOME/run-YYYYMMDD-HHMMSS.log
  --emoji EMOJI       Use EMOJI instead of random
  --style STYLE       figlet font (default: slant)
  --email ADDR        Show hacker email in header (default: ${HACKER_EMAIL})
  --ascii PATH        Use ASCII art from PATH instead of figlet banner
  --help              Show this help
Examples:
  $0 --center --log --emoji "🔐" --style block --email you@host -- git status
  $0 --ascii ~/logo.txt -- echo "hello"
If you put '--' before command it treats everything after as the command.
EOF
  exit 1
}

# center_text: prints single line centered
center_text() {
  local text="$1"
  local width
  width=$(tput cols 2>/dev/null || echo 80)
  local pad=$(( (width - ${#text}) / 2 ))
  (( pad<0 )) && pad=0
  printf "%*s%s\n" "$pad" "" "$text"
}

# print_boxed_header: multi-line header inside a box (centered optionally)
print_boxed_header() {
  local left="$1"   # main header (emoji + prefix + command)
  local right="$2"  # email / extra
  local ts="$3"
  local line_len=58
  local top
  top="$(printf '═%.0s' $(seq 1 $line_len))"
  local middle="${left} · ${ts}"
  [ -n "$right" ] && middle="${middle}  |  ${right}"

  if $CENTER; then
    center_text "${COLOR_BOX}╔${top}╗${NC}"
    center_text "${COLOR_BOX}║${NC} ${COLOR_EM}${middle}${NC} ${COLOR_BOX}║${NC}"
    center_text "${COLOR_BOX}╚${top}╝${NC}"
  else
    echo -e "${COLOR_BOX}╔${top}╗${NC}"
    echo -e "${COLOR_BOX}║${NC} ${COLOR_EM}${middle}${NC} ${COLOR_BOX}║${NC}"
    echo -e "${COLOR_BOX}╚${top}╝${NC}"
  fi
}

# print_banner: big ASCII banner (figlet) or custom ASCII file
print_banner() {
  if [ -n "$ASCII_FILE" ]; then
    if [ -f "$ASCII_FILE" ]; then
      if $CENTER; then
        while IFS= read -r ln; do center_text "$ln"; done < "$ASCII_FILE"
      else
        cat "$ASCII_FILE"
      fi
      return
    else
      echo -e "${COLOR_FAIL}[!] ASCII file not found: $ASCII_FILE${NC}"
      return
    fi
  fi

  # figlet banner if available
  if command -v figlet >/dev/null 2>&1; then
    local txt="RUNNER"
    # If user passed a very short command, show that as banner instead for fun
    # we will not use the full command (could be long). Keep static "RUNNER"
    if command -v lolcat >/dev/null 2>&1; then
      if $CENTER; then
        figlet -f "$BANNER_STYLE" "$txt" | lolcat | while IFS= read -r ln; do center_text "$ln"; done
      else
        figlet -f "$BANNER_STYLE" "$txt" | lolcat
      fi
    else
      if $CENTER; then
        figlet -f "$BANNER_STYLE" "$txt" | while IFS= read -r ln; do center_text "$ln"; done
      else
        figlet -f "$BANNER_STYLE" "$txt"
      fi
    fi
  else
    # simple fallback header
    local fallback="=== RUNNER ==="
    if $CENTER; then center_text "${COLOR_BANNER}${fallback}${NC}"; else echo -e "${COLOR_BANNER}${fallback}${NC}"; fi
  fi
}

# ----------------------------
# Parse flags
# ----------------------------
# allow flags before command; using '--' recommended to separate command
while [[ $# -gt 0 ]]; do
  case "$1" in
    --center) CENTER=true; shift ;;
    --log) LOG=true; shift ;;
    --emoji) shift; EMOJI="$1"; shift ;;
    --style) shift; BANNER_STYLE="$1"; shift ;;
    --email) shift; HACKER_EMAIL="$1"; shift ;;
    --ascii) shift; ASCII_FILE="$1"; shift ;;
    --help|-h) usage ;;
    --) shift; break ;;
    -*)
      echo "Unknown option: $1"; usage ;;
    *) break ;;
  esac
done

# The rest is the command to run; if none, use demo
if [[ $# -eq 0 ]]; then
  CMD_STR='echo "Demo: Hello Hacker!"'
else
  # preserve the command exactly as given
  CMD_STR="$*"
fi

# choose emoji
if [[ -z "$EMOJI" ]]; then
  EMOJI="${EMOJI_POOL[$RANDOM % ${#EMOJI_POOL[@]}]}"
fi

TS="$(date '+%Y-%m-%d %H:%M:%S')"
LEFT_HEADER="${EMOJI} ${PREFIX} ${CMD_STR}"

# ----------------------------
# Show UI
# ----------------------------
# banner
print_banner
# header box
print_boxed_header "$LEFT_HEADER" "$HACKER_EMAIL" "$TS"

# ----------------------------
# Execute command (with optional logging)
# ----------------------------
EXIT_CODE=0
if $LOG; then
  LOGFILE="$HOME/run-$(date '+%Y%m%d-%H%M%S').log"
  echo -e "${COLOR_OK}[i] Logging to: ${LOGFILE}${NC}"
  # store header in logfile
  echo "[$TS] $LEFT_HEADER | $HACKER_EMAIL" >> "$LOGFILE"
  # execute and tee
  bash -c "$CMD_STR" 2>&1 | tee -a "$LOGFILE"
  EXIT_CODE=${PIPESTATUS[0]:-0}
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] exit:$EXIT_CODE" >> "$LOGFILE"
else
  bash -c "$CMD_STR"
  EXIT_CODE=$?
fi

# ----------------------------
# Result display
# ----------------------------
if [[ $EXIT_CODE -eq 0 ]]; then
  echo -e "${COLOR_OK}[✓] Command finished successfully (exit: ${EXIT_CODE})${NC}"
else
  FAIL_EMOJI="${FAIL_EMOJIS[$RANDOM % ${#FAIL_EMOJIS[@]}]}"
  if $CENTER; then
    center_text "${COLOR_FAIL}${FAIL_EMOJI}  Command FAILED (exit: ${EXIT_CODE})  ${FAIL_EMOJI}${NC}"
  else
    echo -e "${COLOR_FAIL}${FAIL_EMOJI}  Command FAILED (exit: ${EXIT_CODE})  ${FAIL_EMOJI}${NC}"
  fi
  if $LOG; then
    echo -e "${COLOR_TS}[i] Full output saved to: ${LOGFILE}${NC}"
  else
    echo -e "${COLOR_TS}[i] Tip: rerun with --log to capture full output${NC}"
  fi
fi

# exit with the command's status
exit $EXIT_CODE