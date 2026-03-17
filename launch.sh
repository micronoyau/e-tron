PROJECT_UID=$(pwd -P | sha256sum | awk '{print $1}')
EXPLOITRON_SESSION_DIR=$HOME/.local/share/exploitron/$PROJECT_UID
OPENCODE_CREDS=$HOME/.local/share/opencode/auth.json

if [ ! -d $EXPLOITRON_SESSION_DIR ]; then
  echo "Creating exploitron session in $EXPLOITRON_SESSION_DIR ..."
  mkdir -p $EXPLOITRON_SESSION_DIR/opencode $EXPLOITRON_SESSION_DIR/local
  cp $OPENCODE_CREDS $EXPLOITRON_SESSION_DIR/opencode
fi

docker run \
  --rm \
  -it \
  --mount type=bind,source="$(pwd)",target="/home/user/chal" \
  --mount type=bind,source="$EXPLOITRON_SESSION_DIR/local",target="/home/user/.local/share" \
  --mount type=bind,source="$EXPLOITRON_SESSION_DIR/opencode",target="/home/user/.local/share/opencode" \
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
