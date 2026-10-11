extends Node

# Carries run settings from the setup screen into the run, and the result
# back out to the end screen (change_scene_to_file can't pass arguments).

enum Mode { TIMED, SURVIVAL }
enum Difficulty { EASY, MEDIUM, HARD }
enum TypoRule { STUMBLE, FREEZE }

var mode: Mode = Mode.TIMED
var difficulty: Difficulty = Difficulty.EASY
var typo_rule: TypoRule = TypoRule.STUMBLE
var timed_length_s: float = 60.0
var baseline_wpm: float
var last_result: Dictionary = {}


func _ready() -> void:
	baseline_wpm = Config.t.default_baseline_wpm
