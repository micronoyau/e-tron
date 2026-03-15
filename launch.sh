docker run \
  --rm \
  -it \
  --mount type=bind,source="$(pwd)",target="/home/user/chal" \
  --mount type=bind,source="${HOME}/.local/share/opencode/auth.json",target="/home/user/.local/share/opencode/auth.json" \
  --mount type=bind,source="${HOME}/Downloads",target="/root/Downloads" \
  --mount type=bind,source="${XDG_RUNTIME_DIR}/${WAYLAND_DISPLAY}",target="/tmp/${WAYLAND_DISPLAY}" \
  -e XDG_RUNTIME_DIR=/tmp \
  -e WAYLAND_DISPLAY=${WAYLAND_DISPLAY} \
  --mount type=bind,source="${XDG_RUNTIME_DIR}/pipewire-0",target="/tmp/pipewire-0" \
  --device /dev/dri \
  --device /dev/snd \
  --name exploitron \
  exploitron:latest \
  zsh
