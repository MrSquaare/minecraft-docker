#!/usr/bin/env bash

# FUNCTIONS

## ECHO FUNCTIONS

echo_error() {
  echo "[minecraft:run] [ERROR] $1"
}

echo_info() {
  echo "[minecraft:run] [INFO] $1"
}

echo_success() {
  echo "[minecraft:run] [SUCCESS] $1"
}

## PROGRAM FUNCTIONS

run() {
  echo_info "Running server..."

  if java -Xmx"${JAVA_XMX:-1024M}" -Xms"${JAVA_XMS:-1024M}" -jar "$SERVER_FILE" "$SERVER_ARGUMENTS"; then
    echo_success "Ran server"
  else
    echo_error "Can't run server" && exit 1
  fi
}

# PROGRAM

cd "$DATA_DIRECTORY" || exit 1

run
