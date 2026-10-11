extends Control

# The website's orange SLYRUN logo (its .okey keys): six orange keycaps, each nudged and tilted
# a little, as the website's LOGO table does once the keys land.

const LETTERS := "SLYRUN"
# Letter: [downward offset as a fraction of the key size, tilt in degrees].
const LOGO := {
	"S": [0.10, -2.0], "L": [-0.30, 2.0], "Y": [-0.06, -2.0],
	"R": [0.08, 1.0], "U": [0.05, -1.0], "N": [0.10, 2.0],
}
# The website's gap between keys, as a fraction of the key size.
const GAP_RATIO := 0.16

@export var key_size := 64.0


func _ready() -> void:
	var gap := key_size * GAP_RATIO
	# Room for the highest (L, -0.30) and lowest (S/N, +0.10) keys.
	custom_minimum_size = Vector2(LETTERS.length() * key_size + (LETTERS.length() - 1) * gap, key_size * 1.4)
	var font: Font = load("res://assets/fonts/IBMPlexMono-Medium.ttf")
	for i in LETTERS.length():
		var letter := LETTERS[i]
		var key := PanelContainer.new()
		key.theme_type_variation = &"KeycapOrange"
		key.position = Vector2(i * (key_size + gap), key_size * (0.3 + LOGO[letter][0]))
		key.size = Vector2(key_size, key_size)
		key.pivot_offset = key.size / 2
		key.rotation_degrees = LOGO[letter][1]
		var label := Label.new()
		label.text = letter
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		label.add_theme_font_override("font", font)
		label.add_theme_font_size_override("font_size", int(key_size * 0.46))
		label.add_theme_color_override("font_color", Palette.KEY_LETTER)
		key.add_child(label)
		add_child(key)
