extends Node

# Carries run settings from the setup screen into the run, and the result
# back out to the end screen (change_scene_to_file can't pass arguments).

# Timed counts down from timed_length_s; Journey runs until Sly is caught.
enum Mode { TIMED, JOURNEY }
enum Difficulty { EASY, MEDIUM, HARD }
enum TypoRule { STUMBLE, FREEZE }

const TIMED_LENGTHS: Array[float] = [30.0, 60.0, 120.0]

var mode: Mode = Mode.TIMED
var difficulty: Difficulty = Difficulty.EASY
var typo_rule: TypoRule = TypoRule.STUMBLE
var timed_length_s: float = 60.0
var baseline_wpm: float
var last_result: Dictionary = {}


func _ready() -> void:
	baseline_wpm = Config.t.default_baseline_wpm


# The name players see, on the title screen and the run's mode label.
func mode_label() -> String:
	return "Journey" if mode == Mode.JOURNEY else "Timed"
