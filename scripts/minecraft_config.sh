#!/usr/bin/env bash

# VARIABLES

EULA=${EULA:-false}

EULA_FILE="$DATA_DIRECTORY/eula.txt"
SERVER_PROPERTIES_FILE="$DATA_DIRECTORY/server.properties"

# FUNCTIONS

## ECHO FUNCTIONS

echo_error() {
  echo "[minecraft:config] [ERROR] $1"
}

echo_info() {
  echo "[minecraft:config] [INFO] $1"
}

echo_success() {
  echo "[minecraft:config] [SUCCESS] $1"
}

## PROGRAM FUNCTIONS

generate() {
  if [[ ! -f "$EULA_FILE" ]] || [[ ! -f "$SERVER_PROPERTIES_FILE" ]]; then
    echo_info "Generating eula.txt and server.properties..."

    if java -Dcom.mojang.eula.agree=false -jar "$SERVER_FILE" >/dev/null; then
      echo_success "Generated eula.txt and server.properties"
    else
      echo_error "Can't generate eula.txt and server.properties" && exit 1
    fi
  fi
}

config_eula() {
  echo_info "Configuring eula.txt..."

  if sed -i "s/eula=.*/eula=$EULA/g" "$EULA_FILE"; then
    echo_success "Configured eula.txt"
  else
    echo_error "Can't configure eula.txt" && exit 1
  fi
}

config_server_properties() {
  echo_info "Configuring server.properties..."

  if ! cp "$SERVER_PROPERTIES_FILE" "$SERVER_PROPERTIES_FILE.tmp"; then
    echo_error "Can't configure server.properties (cp)" && exit 1
  fi

  while read -r line; do
    if echo "$line" | grep -qE '^#'; then
      continue
    fi

    key=$(echo "$line" | cut -d '=' -f1)
    env_key=$(echo "$key" | sed 's/[-.]/_/g' | tr '[:lower:]' '[:upper:]')
    env_value=${!env_key}

    if [[ -n "$env_value" ]]; then
      if ! sed -i "s/$key=.*/$key=$env_value/g" "$SERVER_PROPERTIES_FILE.tmp"; then
        echo_error "Can't configure server.properties (sed)" && exit 1
      fi
    fi
  done <"$SERVER_PROPERTIES_FILE"

  if ! mv -f "$SERVER_PROPERTIES_FILE.tmp" "$SERVER_PROPERTIES_FILE"; then
    echo_error "Can't configure server.properties (mv)" && exit 1
  fi

  echo_success "Configured server.properties"
}

# PROGRAM

cd "$DATA_DIRECTORY" || exit 1

generate
config_eula
config_server_properties
