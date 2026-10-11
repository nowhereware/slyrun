extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$PlayButton.button_down.connect(onPlayButtonPress)

func onPlayButtonPress():
	Router.goto_run()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
