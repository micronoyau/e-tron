PROJECT_UID=$(pwd -P | sha256sum | awk '{print $1}')
OPENCODE_SHARE_DIR=$HOME/.local/share/exploitron/$PROJECT_UID
OPENCODE_CREDS=$HOME/.local/share/opencode/auth.json

if [ ! -d $OPENCODE_SHARE_DIR ]; then
  echo "Creating opencode share dir in $OPENCODE_SHARE_DIR ..."
  mkdir -p $OPENCODE_SHARE_DIR
  cp $OPENCODE_CREDS $OPENCODE_SHARE_DIR
fi

docker run \
  --rm \
  -it \
  --mount type=bind,source="$(pwd)",target="/home/user/chal" \
  --mount type=bind,source="$OPENCODE_SHARE_DIR",target="/home/user/.local/share/opencode/" \
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
