extends Node2D

@onready var menu := $UI/Menu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	menu.get_node("PlayButton").button_down.connect(onPlayButtonPress)

	# The toggles start on whatever GameState already holds and write straight back to it.
	var journey: Button = menu.get_node("ModeRow/ModeButtons/Journey")
	var timed: Button = menu.get_node("ModeRow/ModeButtons/Timed")
	journey.button_pressed = GameState.mode == GameState.Mode.JOURNEY
	timed.button_pressed = GameState.mode == GameState.Mode.TIMED
	journey.pressed.connect(set_mode.bind(GameState.Mode.JOURNEY))
	timed.pressed.connect(set_mode.bind(GameState.Mode.TIMED))

	var length_buttons: Array[Button] = [
		menu.get_node("LengthRow/LengthButtons/Length30"),
		menu.get_node("LengthRow/LengthButtons/Length60"),
		menu.get_node("LengthRow/LengthButtons/Length120"),
	]
	for i in length_buttons.size():
		var length: float = GameState.TIMED_LENGTHS[i]
		length_buttons[i].button_pressed = is_equal_approx(GameState.timed_length_s, length)
		length_buttons[i].pressed.connect(set_timed_length.bind(length))

	menu.get_node("LengthRow").visible = GameState.mode == GameState.Mode.TIMED

# Space starts the run, like the website. The buttons never take focus, so Space can't also
# press one of them; key repeats are ignored so a held key doesn't start a run on arrival.
func _unhandled_input(event: InputEvent) -> void:
	if (event is InputEventKey and event.pressed and !event.is_echo() and event.keycode == KEY_SPACE):
		get_viewport().set_input_as_handled()
		onPlayButtonPress()

func onPlayButtonPress():
	Router.goto_run()

func set_mode(mode: GameState.Mode) -> void:
	GameState.mode = mode
	menu.get_node("LengthRow").visible = mode == GameState.Mode.TIMED

func set_timed_length(seconds: float) -> void:
	GameState.timed_length_s = seconds
