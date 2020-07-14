# IMPORTS

. minecraft_library.sh

# VARIABLES

FORCE_COPY=${FORCE_COPY:-false}
FORCE_DOWNLOAD=${FORCE_DOWNLOAD:-false}

MINECRAFT_TYPE=${MINECRAFT_TYPE:-release}
MINECRAFT_VERSION=${MINECRAFT_VERSION:-latest}

MINECRAFT_VERSION_FILE="$DATA_DIRECTORY/.version"

# FUNCTIONS

## ECHO FUNCTIONS

echo_error() {
  echo "[minecraft:setup] [ERROR] $1"
}

echo_info() {
  echo "[minecraft:setup] [INFO] $1"
}

echo_success() {
  echo "[minecraft:setup] [SUCCESS] $1"
}

# PROGRAM

if [ ! -d "$BUILD_DIRECTORY" ]; then
  mkdir -p "$BUILD_DIRECTORY" || exit 1
fi

if [ ! -d "$DATA_DIRECTORY" ]; then
  mkdir -p "$DATA_DIRECTORY" || exit 1
fi

if [ ! -d "$DOWNLOAD_DIRECTORY" ]; then
  mkdir -p "$DOWNLOAD_DIRECTORY" || exit 1
fi

MINECRAFT_VERSION=$(get_version "$MINECRAFT_VERSION" "$MINECRAFT_TYPE" | jq -r ".id")

if [ -z "$MINECRAFT_VERSION" ]; then
  echo_error "Version not found. Verify that the $MINECRAFT_VERSION ($MINECRAFT_TYPE) version exists." && exit 1
fi

if [ -f "$MINECRAFT_VERSION_FILE" ]; then
  minecraft_version=$(cat "$MINECRAFT_VERSION_FILE")

  if [ "$minecraft_version" != "$MINECRAFT_VERSION" ]; then
    FORCE_COPY="true"
  fi
else
  FORCE_COPY="true"
fi

echo "$MINECRAFT_VERSION" >"$MINECRAFT_VERSION_FILE"

export FORCE_COPY
export FORCE_DOWNLOAD
export MINECRAFT_TYPE
export MINECRAFT_VERSION
