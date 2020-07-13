#!/usr/bin/env sh

. minecraft_library.sh

# VARIABLES

export MINECRAFT_TYPE=${MINECRAFT_TYPE:-release}
export MINECRAFT_VERSION=${MINECRAFT_VERSION:-latest}

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

export MINECRAFT_VERSION=$(get_version "$MINECRAFT_VERSION" "$MINECRAFT_TYPE" | jq -r ".id")

if [ -z "$MINECRAFT_VERSION" ]; then
  echo_error "Version not found. Verify that the $MINECRAFT_VERSION ($MINECRAFT_TYPE) version exists." && exit 1
fi
