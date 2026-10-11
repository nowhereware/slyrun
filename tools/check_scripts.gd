extends SceneTree

# Loads every script given after `--` and exits 1 if any fails to compile.
# Usage: godot --headless --path . --script res://tools/check_scripts.gd -- res://src/a.gd res://src/b.gd
#
# The web export only tokenizes scripts, so syntax and type errors would otherwise ship.
# `--check-only` can't be used instead: it compiles without autoloads, so any script that
# uses Config, Router and the like fails there even when it's fine. Here the autoloads exist.

func _initialize() -> void:
	var paths := OS.get_cmdline_user_args()
	if paths.is_empty():
		push_error("check_scripts: no scripts given. Pass res:// paths after --.")
		quit(1)
		return

	var failed: Array[String] = []
	for path in paths:
		# Reloading the script that's running crashes Godot 4.7 (signal 11), and it compiled to get here.
		if path == get_script().resource_path:
			continue
		var script := ResourceLoader.load(path, "", ResourceLoader.CACHE_MODE_IGNORE) as Script
		if script == null or not script.can_instantiate():
			failed.append(path)

	if failed.is_empty():
		print("check_scripts: all %d scripts load." % paths.size())
		quit(0)
	else:
		# The SCRIPT ERROR lines above say what's wrong in each file.
		printerr("check_scripts: %d of %d scripts failed to load: %s" % [failed.size(), paths.size(), ", ".join(failed)])
		quit(1)
