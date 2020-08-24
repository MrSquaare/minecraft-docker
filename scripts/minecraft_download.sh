#!/usr/bin/env bash

# IMPORTS

. minecraft_library.sh

# VARIABLES

MINECRAFT_FILE="minecraft-$MINECRAFT_VERSION.jar"

# FUNCTIONS

## ECHO FUNCTIONS

echo_error() {
  echo "[minecraft:download] [ERROR] $1"
}

echo_info() {
  echo "[minecraft:download] [INFO] $1"
}

echo_success() {
  echo "[minecraft:download] [SUCCESS] $1"
}

## PROGRAM FUNCTIONS

download() {
  if [[ ! -f "$MINECRAFT_FILE" ]] || [[ "$FORCE_DOWNLOAD" == "true" ]]; then
    server_url=$(get_version "$MINECRAFT_VERSION" "$MINECRAFT_TYPE" | jq -r ".downloads.server.url")

    echo_info "Downloading $MINECRAFT_FILE..."

    if curl --progress-bar "$server_url" -o "$MINECRAFT_FILE"; then
      echo_success "Downloaded $MINECRAFT_FILE"
    else
      echo_error "Can't download $MINECRAFT_FILE" && exit 1
    fi

    FORCE_COPY=true
  fi
}

copy() {
  if [[ ! -f "$SERVER_FILE" ]] || [[ "$FORCE_COPY" == "true" ]]; then
    echo_info "Copying $MINECRAFT_FILE to $SERVER_FILE..."

    if cp -f "$MINECRAFT_FILE" "$SERVER_FILE"; then
      echo_success "Copied $MINECRAFT_FILE"
    else
      echo_error "Can't copy $MINECRAFT_FILE" && exit 1
    fi
  fi
}

# PROGRAM

cd "$DOWNLOAD_DIRECTORY" || exit 1

download
copy
