class_name Tuning
extends Resource

# Every gameplay number lives here so it can be tweaked in the inspector
# (data/tuning.tres) without touching code.

@export_group("Run")
@export var head_start_s: float = 4.0
@export var wpm_window_s: float = 3.0
@export var default_baseline_wpm: float = 40.0
@export var calibration_length_s: float = 30.0
# Survival distance = Sly's speed × time × this.
@export var distance_multiplier: float = 10.0

@export_group("Difficulty")
# Fraction of the player's baseline WPM they must sustain to hold the gap.
@export var easy_multiplier: float = 0.75
@export var medium_multiplier: float = 0.90
@export var hard_multiplier: float = 1.05
@export var survival_ramp_interval_s: float = 10.0
@export var landscape_interval_s: float = 30.0

@export_group("Typo rules")
# Hollow speed multiplier while Sly is frozen in Freeze mode.
@export var freeze_hollow_speed: float = 0.5

@export_group("Danger zones")
# Gap thresholds in seconds of lead; at or below 0 Sly is caught.
@export var warning_gap_s: float = 3.0
@export var danger_gap_s: float = 2.0
@export var critical_gap_s: float = 1.0
