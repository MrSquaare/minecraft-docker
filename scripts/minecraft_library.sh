# VARIABLES

MINECRAFT_VERSION_MANIFEST_URL="https://launchermeta.mojang.com/mc/game/version_manifest.json"

# FUNCTIONS

## CURL FUNCTIONS

curl_data() {
  curl "$@" | sed 's/\\/\\\\/g'
}

## GET FUNCTIONS

get_version() {
  minecraft_version=$1
  minecraft_type=$2

  manifest_data=$(curl_data -s "$MINECRAFT_VERSION_MANIFEST_URL")

  if [ "$minecraft_version" = "latest" ]; then
    case "$minecraft_type" in
    release | snapshot)
      minecraft_version=$(echo "$manifest_data" | jq -r ".latest.$minecraft_type")
      ;;
    esac
  fi

  manifest_version_data=$(echo "$manifest_data" | jq -r ".versions[] | select(.id == \"$minecraft_version\")")
  version_url=$(echo "$manifest_version_data" | jq -r ".url")
  version_data=$(curl_data -s "$version_url")

  echo "$version_data"
}
