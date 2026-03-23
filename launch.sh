#!/usr/bin/env bash
set -euo pipefail

PROJECT_UID=$(pwd -P | sha256sum | awk '{print $1}')
EXPLOITRON_SESSION_DIR="$HOME/.local/share/exploitron/$PROJECT_UID"
OPENCODE_CREDS="$HOME/.local/share/opencode/auth.json"
CLAUDE_JSON="$HOME/.claude.json"
CLAUDE_CREDS="$HOME/.claude/.credentials.json"

if [[ ! -d "$EXPLOITRON_SESSION_DIR" ]]; then
  echo "Creating exploitron session in $EXPLOITRON_SESSION_DIR ..."
  mkdir -p "$EXPLOITRON_SESSION_DIR"/{opencode,local,nvim_cache}
  cp "$CLAUDE_JSON" "$EXPLOITRON_SESSION_DIR/.claude.json"
fi

docker run \
  --rm \
  -it \
  --mount "type=bind,source=$(pwd),target=/home/user/chal" \
  --mount "type=bind,source=${XDG_RUNTIME_DIR}/${WAYLAND_DISPLAY},target=/tmp/${WAYLAND_DISPLAY}" \
  --mount "type=bind,ro,source=${OPENCODE_CREDS},target=/home/user/.local/share/opencode/auth.json" \
  --mount "type=bind,source=${EXPLOITRON_SESSION_DIR}/.claude.json,target=/home/user/.claude.json" \
  --mount "type=bind,ro,source=${CLAUDE_CREDS},target=/home/user/.claude/.credentials.json" \
  --mount "type=bind,source=${EXPLOITRON_SESSION_DIR}/nvim_cache,target=/home/user/.local/share/nvim" \
  --mount "type=bind,source=${XDG_RUNTIME_DIR}/pipewire-0,target=/tmp/pipewire-0" \
  -e XDG_RUNTIME_DIR=/tmp \
  -e WAYLAND_DISPLAY="${WAYLAND_DISPLAY}" \
  --device /dev/dri \
  --device /dev/snd \
  --name exploitron \
  exploitron:latest \
  zsh
