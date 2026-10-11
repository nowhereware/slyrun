extends Node

# The only place that changes scenes. Add a constant and a goto_* here when a
# new screen exists.

const TITLE := "res://src/menus/title/title.tscn"
const RUN := "res://src/run/run.tscn"


func goto_title() -> void:
	_goto(TITLE)


func goto_run() -> void:
	_goto(RUN)


func _goto(path: String) -> void:
	var err := get_tree().change_scene_to_file(path)
	if err != OK:
		push_error("Router: couldn't open %s (error %d)." % [path, err])
