FROM alpine:3.12

ARG IMAGE_CREATION
ARG IMAGE_VERSION

LABEL fr.mrsquaare.image.created=${IMAGE_CREATION}
LABEL fr.mrsquaare.image.authors="MrSquaare <contact@mrsquaare.fr> (@MrSquaare)"
LABEL fr.mrsquaare.image.url="https://hub.docker.com/r/mrsquaare/minecraft-docker"
LABEL fr.mrsquaare.image.source="https://github.com/MrSquaare/minecraft-docker"
LABEL fr.mrsquaare.image.version=${IMAGE_VERSION}
LABEL fr.mrsquaare.image.vendor="MrSquaare"
LABEL fr.mrsquaare.image.licenses="MIT"
LABEL fr.mrsquaare.image.title="Minecraft Docker"
LABEL fr.mrsquaare.image.description="Docker image for Minecraft server"

RUN apk update && \
    apk upgrade

RUN apk add \
    bash \
    curl \
    git \
    jq \
    openjdk8-jre

ENV USER="minecraft"
ENV GID="1000"
ENV UID="1000"

ENV ROOT_DIRECTORY="/srv/minecraft"
ENV BUILD_DIRECTORY="${ROOT_DIRECTORY}/build"
ENV DATA_DIRECTORY="${ROOT_DIRECTORY}/data"
ENV DOWNLOAD_DIRECTORY="${ROOT_DIRECTORY}/download"

ENV SERVER_FILE="${DATA_DIRECTORY}/server.jar"

SHELL ["/bin/bash", "-c"]

COPY docker-entrypoint.sh /usr/local/bin
COPY scripts/ /usr/local/bin

RUN addgroup -S -g ${GID} ${USER} && \
    adduser -DS -u ${UID} -G ${USER} ${USER}

USER ${USER}

ENTRYPOINT ["docker-entrypoint.sh"]
