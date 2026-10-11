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
	# Deferred calls drop the return code, so check the scene exists up front.
	if not ResourceLoader.exists(path):
		push_error("Router: scene %s doesn't exist; staying on the current screen." % path)
		return
	# Deferred so screens can route from their own _ready() without hitting
	# "Parent node is busy adding/removing children".
	get_tree().change_scene_to_file.call_deferred(path)
