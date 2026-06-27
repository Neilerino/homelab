#!/usr/bin/env bash

set -euo pipefail

SSH_USER="${SSH_USER:-neil}"
SSH_HOST="${SSH_HOST:-192.168.1.218}"
LOCAL_PORT="${LOCAL_PORT:-4646}"
NOMAD_HOST="${NOMAD_HOST:-127.0.0.1}"
NOMAD_PORT="${NOMAD_PORT:-4646}"
NOMAD_URL="http://127.0.0.1:${LOCAL_PORT}"

if [ "${1:-}" = "-h" ] || [ "${1:-}" = "--help" ]; then
  cat <<EOF
Usage: $(basename "$0")

Opens an SSH tunnel to Nomad on the homelab host.

Environment overrides:
  SSH_USER     default: $SSH_USER
  SSH_HOST     default: $SSH_HOST
  LOCAL_PORT   default: $LOCAL_PORT
  NOMAD_HOST   default: $NOMAD_HOST
  NOMAD_PORT   default: $NOMAD_PORT

Example:
  SSH_HOST=zapdos.local $(basename "$0")
EOF
  exit 0
fi

echo "Opening Nomad tunnel: http://127.0.0.1:${LOCAL_PORT}"
echo "Forwarding ${SSH_USER}@${SSH_HOST} ${NOMAD_HOST}:${NOMAD_PORT} -> 127.0.0.1:${LOCAL_PORT}"
echo "Press Ctrl-C to close the tunnel."

open_nomad() {
  sleep 1

  if command -v open >/dev/null 2>&1; then
    open -a "Google Chrome" "$NOMAD_URL" || open "$NOMAD_URL"
  elif command -v xdg-open >/dev/null 2>&1; then
    xdg-open "$NOMAD_URL" >/dev/null 2>&1
  else
    echo "Open $NOMAD_URL in your browser."
  fi
}

open_nomad &

exec ssh \
  -N \
  -L "127.0.0.1:${LOCAL_PORT}:${NOMAD_HOST}:${NOMAD_PORT}" \
  "${SSH_USER}@${SSH_HOST}"
