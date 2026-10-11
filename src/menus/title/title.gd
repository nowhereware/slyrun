extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$PlayButton.button_down.connect(onPlayButtonPress)

	# The toggles start on whatever GameState already holds and write straight back to it.
	$ModeButtons/Journey.button_pressed = GameState.mode == GameState.Mode.JOURNEY
	$ModeButtons/Timed.button_pressed = GameState.mode == GameState.Mode.TIMED
	$ModeButtons/Journey.pressed.connect(set_mode.bind(GameState.Mode.JOURNEY))
	$ModeButtons/Timed.pressed.connect(set_mode.bind(GameState.Mode.TIMED))

	var length_buttons: Array[Button] = [$LengthButtons/Length30, $LengthButtons/Length60, $LengthButtons/Length120]
	for i in length_buttons.size():
		var length: float = GameState.TIMED_LENGTHS[i]
		length_buttons[i].button_pressed = is_equal_approx(GameState.timed_length_s, length)
		length_buttons[i].pressed.connect(set_timed_length.bind(length))

	$LengthButtons.visible = GameState.mode == GameState.Mode.TIMED

func onPlayButtonPress():
	Router.goto_run()

func set_mode(mode: GameState.Mode) -> void:
	GameState.mode = mode
	$LengthButtons.visible = mode == GameState.Mode.TIMED

func set_timed_length(seconds: float) -> void:
	GameState.timed_length_s = seconds

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
