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

if [[ ! -d "$BUILD_DIRECTORY" ]]; then
  if ! mkdir -p "$BUILD_DIRECTORY"; then
    echo_error "Can't create build directory" && exit 1
  fi
fi

if [[ ! -d "$DATA_DIRECTORY" ]]; then
  if ! mkdir -p "$DATA_DIRECTORY"; then
    echo_error "Can't create data directory" && exit 1
  fi
fi

if [[ ! -d "$DOWNLOAD_DIRECTORY" ]]; then
  if ! mkdir -p "$DOWNLOAD_DIRECTORY"; then
    echo_error "Can't create download directory" && exit 1
  fi
fi

minecraft_get_version=$(get_version "$MINECRAFT_VERSION" "$MINECRAFT_TYPE" | jq -r ".id")

if [[ -z "$minecraft_get_version" ]]; then
  echo_error "Version not found. Verify that the $MINECRAFT_VERSION ($MINECRAFT_TYPE) version exists." && exit 1
fi

MINECRAFT_VERSION=$minecraft_get_version

if [[ -f "$MINECRAFT_VERSION_FILE" ]]; then
  minecraft_last_version=$(cat "$MINECRAFT_VERSION_FILE")

  if [[ "$minecraft_last_version" != "$MINECRAFT_VERSION" ]]; then
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
