#!/usr/bin/env bash
# Exports the "Web" preset into site/play/, next to the website in site/index.html.
# Usage: tools/build_web.sh   (set GODOT to use a specific Godot binary)
set -euo pipefail

cd "$(dirname "$0")/.."

# GODOT wins; otherwise `godot` on PATH (how CI installs it), then the default macOS install.
if [[ -z "${GODOT:-}" ]]; then
	if command -v godot >/dev/null 2>&1; then
		GODOT="$(command -v godot)"
	else
		GODOT="/Applications/Godot.app/Contents/MacOS/Godot"
	fi
fi
OUT_DIR="site/play"

if [[ ! -x "$GODOT" ]]; then
	echo "build_web: Godot not found at '$GODOT'. Install Godot 4.7.x, put it on PATH as 'godot', or set GODOT to its binary." >&2
	exit 1
fi

# "4.7.2.stable.official.ed1daf0bf" -> "4.7.2.stable", the folder name Godot looks for.
version="$("$GODOT" --version | cut -d. -f1-4)"
case "$(uname -s)" in
	Darwin) templates_root="$HOME/Library/Application Support/Godot/export_templates" ;;
	*) templates_root="${XDG_DATA_HOME:-$HOME/.local/share}/godot/export_templates" ;;
esac
# The preset has thread support off, so Godot exports with the "nothreads" template.
template="$templates_root/$version/web_nothreads_release.zip"
if [[ ! -f "$template" ]]; then
	echo "build_web: missing export template $template" >&2
	echo "build_web: install the $version export templates (Editor > Manage Export Templates > Download), then run this again." >&2
	exit 1
fi

rm -rf "$OUT_DIR"
mkdir -p "$OUT_DIR"

if ! "$GODOT" --headless --path . --export-release "Web" "$OUT_DIR/index.html"; then
	echo "build_web: Godot export failed; see the output above." >&2
	exit 1
fi

for f in index.html index.js index.wasm index.pck; do
	if [[ ! -f "$OUT_DIR/$f" ]]; then
		echo "build_web: export finished but $OUT_DIR/$f is missing." >&2
		exit 1
	fi
done

echo "build_web: exported to $OUT_DIR/"
