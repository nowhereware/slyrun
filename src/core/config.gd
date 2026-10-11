extends Node

const TUNING_PATH := "res://data/tuning.tres"

var t: Tuning = _load_tuning()


func _load_tuning() -> Tuning:
	var res := load(TUNING_PATH) as Tuning
	if res == null:
		# Keep the game playable with the script defaults rather than crashing.
		push_error("Config: couldn't load %s as a Tuning resource; using defaults from tuning.gd." % TUNING_PATH)
		return Tuning.new()
	return res
