extends Node2D

# The website's world as looping layers (art from tools/export_website_art.py), shared by the
# title and the run. Clouds, hills and ground scroll left at different speeds so Sly reads as
# running right; the sky and sun stay put.

# Pixels per second at scroll_speed 1. Negative scrolls left.
const LAYER_SPEEDS := {"Clouds": -10.0, "Hills": -24.0, "Ground": -90.0}

@export var scroll_speed := 1.0:
	set(value):
		scroll_speed = value
		_apply_speeds()

var _paused := false


func _ready() -> void:
	_apply_speeds()


func set_paused(paused: bool) -> void:
	_paused = paused
	_apply_speeds()


func _apply_speeds() -> void:
	# The setter also runs while the scene loads, before the layers exist.
	if not is_node_ready():
		return
	for layer_name in LAYER_SPEEDS:
		var layer: Parallax2D = get_node(layer_name)
		layer.autoscroll.x = 0.0 if _paused else LAYER_SPEEDS[layer_name] * scroll_speed
