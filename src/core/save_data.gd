extends Node

# user:// is backed by IndexedDB on Web exports, so this also persists in the browser.
const SAVE_PATH := "user://save.json"

const DEFAULTS := {
	# 0 means the player hasn't calibrated yet.
	"baseline_wpm": 0.0,
	"personal_bests": {},
	"run_history": [],
	"unlocked_skins": [],
}

var data: Dictionary = DEFAULTS.duplicate(true)


func _ready() -> void:
	load_file()


func load_file() -> void:
	data = DEFAULTS.duplicate(true)
	if not FileAccess.file_exists(SAVE_PATH):
		return

	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		push_error("SaveData: couldn't open %s (error %d); starting with defaults." % [SAVE_PATH, FileAccess.get_open_error()])
		return
	var parsed = JSON.parse_string(file.get_as_text())
	file.close()

	if not (parsed is Dictionary):
		push_warning("SaveData: %s is corrupt; starting with defaults. It will be overwritten on the next save." % SAVE_PATH)
		return

	# Take only known keys with the expected type, so an old or hand-edited
	# file can't put the wrong type into a field.
	for key in DEFAULTS:
		if parsed.has(key) and typeof(parsed[key]) == typeof(DEFAULTS[key]):
			data[key] = parsed[key]


func save_file() -> bool:
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		push_error("SaveData: couldn't write %s (error %d); progress from this session won't be kept." % [SAVE_PATH, FileAccess.get_open_error()])
		return false
	file.store_string(JSON.stringify(data, "\t"))
	file.close()
	return true
