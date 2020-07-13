#!/usr/bin/env sh

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
  if [ ! -f "$EULA_FILE" ] || [ ! -f "$SERVER_PROPERTIES_FILE" ]; then
    echo_info "Generating eula.txt and server.properties..."
    java -Dcom.mojang.eula.agree=false -jar "$SERVER_FILE" >/dev/null &&
      echo_success "Generated eula.txt and server.properties" ||
      (echo_error "Can't generate eula.txt and server.properties" && exit 1)
  fi
}

config_eula() {
  echo_info "Configuring eula.txt..."

  sed -i "s/eula=.*/eula=$EULA/g" "$EULA_FILE" &&
    echo_success "Configured eula.txt" ||
    (echo_error "Can't configure eula.txt" && exit 1)
}

config_server_properties() {
  echo_info "Configuring server.properties..."

  cp "$SERVER_PROPERTIES_FILE" "$SERVER_PROPERTIES_FILE.tmp"

  while read -r line; do
    if echo "$line" | grep -qE '^#'; then
      continue
    fi

    key=$(echo "$line" | cut -d '=' -f1)
    env_key=$(echo "$key" | sed 's/[-.]/_/g' | tr '[:lower:]' '[:upper:]')
    env_value=$(eval echo "\$$env_key")

    if [ -n "$env_value" ]; then
      sed -i "s/$key=.*/$key=$env_value/g" "$SERVER_PROPERTIES_FILE.tmp" ||
        (echo_error "Can't configure server.properties (sed)" && exit 1)
    fi
  done <"$SERVER_PROPERTIES_FILE"

  mv -f "$SERVER_PROPERTIES_FILE.tmp" "$SERVER_PROPERTIES_FILE" ||
    (echo_error "Can't configure server.properties (mv)" && exit 1)

  echo_success "Configured server.properties"
}

# PROGRAM

cd "$DATA_DIRECTORY" || exit 1

generate
config_eula
config_server_properties
