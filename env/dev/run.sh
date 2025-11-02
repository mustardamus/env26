#!/usr/bin/env bash

set -e

ACTION=$1
ENV_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_NAME="$(basename "$ENV_DIR")"
APP_DIR="$(cd "$ENV_DIR/../.." && pwd)"
APP_NAME="$(basename "$APP_DIR")"
CONTAINER_NAME="$APP_NAME-$ENV_NAME"
CONTAINER_HOME_DIR="/home/dev"
CONTAINER_APP_DIR="$CONTAINER_HOME_DIR/app"
CONTAINER_CONFIG_DIR="$CONTAINER_HOME_DIR/.config"
VOLUME_NAME="$CONTAINER_NAME-home"
IMAGE_NAME="$CONTAINER_NAME:latest"

build() {
	if is_running; then
		stop
	fi

	if podman image exists "$IMAGE_NAME"; then
		podman rmi "$IMAGE_NAME"
	fi

	podman build -f "$ENV_DIR/$ENV_NAME.containerfile" -t "$IMAGE_NAME" .
}

run() {
	podman run \
		--name "$CONTAINER_NAME" \
		-d --rm --replace \
		--userns keep-id \
		-p 8091:8080 \
		-w "$CONTAINER_APP_DIR" \
		-v "$APP_DIR:$CONTAINER_APP_DIR:Z" \
		-v "$VOLUME_NAME:$CONTAINER_HOME_DIR:Z" \
		-v "$ENV_DIR/fish/config.fish:$CONTAINER_CONFIG_DIR/fish/config.fish:Z" \
		-v "$ENV_DIR/helix:$CONTAINER_CONFIG_DIR/helix:Z" \
		-v "$ENV_DIR/snippets:$CONTAINER_HOME_DIR/.scls/snippets" \
		-v "$ENV_DIR/zellij:$CONTAINER_CONFIG_DIR/zellij:Z" \
		-v "$HOME/.gitconfig:$CONTAINER_HOME_DIR/.gitconfig:ro" \
		"$IMAGE_NAME"
}

stop() {
	podman stop -t 1 "$CONTAINER_NAME"
}

is_running() {
	podman ps --format "{{.Names}}" | grep -q "^$CONTAINER_NAME$"
}

if [ "$ACTION" = "build" ]; then
	build
fi

if [ "$ACTION" = "dev" ]; then
	if ! podman image exists "$IMAGE_NAME"; then
		build
	fi

	if ! is_running; then
		run
	fi

	podman exec "$CONTAINER_NAME" fish -c "zellij delete-session $CONTAINER_NAME || true"
	podman exec -it "$CONTAINER_NAME" fish -c "zellij attach -c $CONTAINER_NAME"
	stop
	clear
fi

if [ "$ACTION" = "reset" ]; then
	podman rmi -f "$IMAGE_NAME"
	podman volume rm "$VOLUME_NAME"
fi
