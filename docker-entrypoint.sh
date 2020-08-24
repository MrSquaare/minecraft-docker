#!/usr/bin/env bash

. minecraft_setup.sh

minecraft_download.sh || exit 1
minecraft_config.sh || exit 1
minecraft_run.sh || exit 1
