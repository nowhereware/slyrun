#!/usr/bin/env bash
# Builds the game and serves the website (site/) with the game at /play/ on this computer.
# Usage: tools/preview_web.sh            then open http://localhost:8000/ (it opens by itself)
#        PORT=8001 tools/preview_web.sh  to use another port
# Ctrl-C stops the server.
set -euo pipefail

cd "$(dirname "$0")/.."

PORT="${PORT:-8000}"
URL="http://localhost:$PORT/"

if lsof -nP -iTCP:"$PORT" -sTCP:LISTEN >/dev/null 2>&1; then
	echo "preview_web: port $PORT is already in use. Stop whatever is using it, or run: PORT=$((PORT + 1)) tools/preview_web.sh" >&2
	exit 1
fi

tools/build_web.sh

python3 -m http.server "$PORT" --bind 127.0.0.1 -d site &
server=$!
# Stop the server however this script ends: Ctrl-C, an error, or the server exiting.
trap 'kill "$server" 2>/dev/null || true' EXIT
trap 'echo; echo "preview_web: stopped."; exit 130' INT TERM

for _ in $(seq 1 50); do
	if curl -s -o /dev/null "$URL"; then
		break
	fi
	if ! kill -0 "$server" 2>/dev/null; then
		echo "preview_web: the web server didn't start; see the message above." >&2
		exit 1
	fi
	sleep 0.1
done

echo "preview_web: the website is at $URL and the game at ${URL}play/. Ctrl-C to stop."
if command -v open >/dev/null 2>&1; then
	open "$URL"
fi
wait "$server"
