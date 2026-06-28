#!/usr/bin/env bash

set -euo pipefail

SSH_USER="${SSH_USER:-neil}"
SSH_HOST="${SSH_HOST:-192.168.1.218}"
HEIMDALL_LOCAL_PORT="${HEIMDALL_LOCAL_PORT:-8083}"
HEIMDALL_REMOTE_PORT="${HEIMDALL_REMOTE_PORT:-83}"
NOMAD_LOCAL_PORT="${NOMAD_LOCAL_PORT:-4646}"
HOMELAB_HOST="${HOMELAB_HOST:-127.0.0.1}"
HEIMDALL_URL="http://127.0.0.1:${HEIMDALL_LOCAL_PORT}"

if [ "${1:-}" = "-h" ] || [ "${1:-}" = "--help" ]; then
  cat <<EOF
Usage: $(basename "$0")

Opens an SSH tunnel to private homelab services and launches Heimdall.

Environment overrides:
  SSH_USER              default: $SSH_USER
  SSH_HOST              default: $SSH_HOST
  HOMELAB_HOST          default: $HOMELAB_HOST
  HEIMDALL_LOCAL_PORT   default: $HEIMDALL_LOCAL_PORT
  HEIMDALL_REMOTE_PORT  default: $HEIMDALL_REMOTE_PORT
  NOMAD_LOCAL_PORT      default: $NOMAD_LOCAL_PORT

Example:
  SSH_HOST=zapdos.local $(basename "$0")
EOF
  exit 0
fi

echo "Opening Heimdall: ${HEIMDALL_URL}"
echo "Forwarding private homelab services through ${SSH_USER}@${SSH_HOST}"
echo
echo "  Heimdall   ${HEIMDALL_URL}"
echo "  Nomad      http://127.0.0.1:${NOMAD_LOCAL_PORT}"
echo "  Jellyfin   http://127.0.0.1:8096"
echo "  Jellyseerr http://127.0.0.1:5055"
echo "  Radarr     http://127.0.0.1:7878"
echo "  Sonarr     http://127.0.0.1:8989"
echo "  SABnzbd    http://127.0.0.1:8080"
echo
echo "Press Ctrl-C to close the tunnel."

open_heimdall() {
  sleep 1

  if command -v open >/dev/null 2>&1; then
    open -a "Google Chrome" "$HEIMDALL_URL" || open "$HEIMDALL_URL"
  elif command -v xdg-open >/dev/null 2>&1; then
    xdg-open "$HEIMDALL_URL" >/dev/null 2>&1
  else
    echo "Open $HEIMDALL_URL in your browser."
  fi
}

open_heimdall &

exec ssh \
  -N \
  -o ExitOnForwardFailure=yes \
  -L "127.0.0.1:${HEIMDALL_LOCAL_PORT}:${HOMELAB_HOST}:${HEIMDALL_REMOTE_PORT}" \
  -L "127.0.0.1:${NOMAD_LOCAL_PORT}:${HOMELAB_HOST}:4646" \
  -L "127.0.0.1:8096:${HOMELAB_HOST}:8096" \
  -L "127.0.0.1:5055:${HOMELAB_HOST}:5055" \
  -L "127.0.0.1:7878:${HOMELAB_HOST}:7878" \
  -L "127.0.0.1:8989:${HOMELAB_HOST}:8989" \
  -L "127.0.0.1:8080:${HOMELAB_HOST}:8080" \
  "${SSH_USER}@${SSH_HOST}"
