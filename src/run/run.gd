extends Node2D

var current_letter: int
var current_word: String
# The word waiting after current_word, shown under it.
var next_word: String
var lines

var total_letters: int
var correct_letters: int
var words_completed: int
var time_elapsed: float

var grace_timer: Timer
var health: int
# Set by end_run(); after that, typing and the clock stop.
var run_over := false

var velocity: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	seed(int(Time.get_unix_time_from_system()))
	current_letter = 0
	var file = FileAccess.open("res://data/words/6letters.csv", FileAccess.READ)
	var letter6 = file.get_as_text()
	file.close()
	# Skip empty lines: the file ends with a newline, and an empty "word" breaks the next keypress.
	lines = letter6.split("\n", false)
	current_word = draw_word()
	next_word = draw_word()
	render_word(false)
	total_letters = 0
	correct_letters = 0
	words_completed = 0
	time_elapsed = 0
	
	grace_timer = Timer.new()
	grace_timer.autostart = false
	grace_timer.one_shot = true
	add_child(grace_timer)
	health = 3
	
	$Tornado.play("default")
	
	$Fox.play("default")

	$HUD/ModeBox/ModeLabel.text = "Mode: " + GameState.mode_label()
	$HUD/GameOverUI/Margin/Results/PlayAgain.pressed.connect(play_again)

func _input(event: InputEvent) -> void:
	if (run_over):
		# Once the results are up, only Space or Enter does anything: play again. Key repeats are
		# ignored so a held key can't skip the results.
		if (event is InputEventKey and event.pressed and !event.is_echo()
				and event.keycode in [KEY_SPACE, KEY_ENTER, KEY_KP_ENTER]):
			play_again()
		return
	if (event is InputEventKey and !event.is_echo() and !event.is_released()):
		event = event as InputEventKey
		if (event.as_text_keycode().to_lower() == current_word[current_letter].to_lower()):
			current_letter += 1
			if (current_letter == current_word.length()):
				# The waiting word comes up, and a new one is drawn to wait behind it.
				current_letter = 0
				current_word = next_word
				next_word = draw_word()
				words_completed += 1
				add_health()
			
			render_word(false)
			correct_letters += 1
		else:
			# Handle health
			if (grace_timer.is_stopped()):
				remove_health()
				grace_timer.start(3)
			
			render_word(true)
		total_letters += 1

func draw_word() -> String:
	return lines[randi() % lines.size()]

# Typed letters bold and black, the current letter underlined in orange (red after a typo),
# the rest grey. The waiting word goes underneath.
func render_word(typo: bool) -> void:
	var word: RichTextLabel = $HUD/WordBox/Word/CurrentWord
	word.clear()
	word.push_color(Palette.INK)
	word.push_bold()
	word.add_text(current_word.substr(0, current_letter))
	word.pop()
	word.pop()
	word.push_color(Palette.TYPO if typo else Palette.INK)
	word.push_underline(Palette.TYPO if typo else Palette.ORANGE_HI)
	word.add_text(current_word[current_letter])
	word.pop()
	word.pop()
	word.push_color(Palette.LEGEND_DIM)
	word.add_text(current_word.substr(current_letter + 1))
	word.pop()
	$HUD/WordBox/Word/NextWord.text = next_word

func remove_health():
	health -= 1
	
	velocity = Vector2(-10, 0)
	
	if (health == 2):
		$Fox.position.x = 500
	elif (health == 1):
		# Move tornado.
		pass
	elif (health == 0):
		$Fox.position.x = 200
		end_run("caught")

# The one place a run ends: "caught" (out of health) or "time_up" (a Timed run finished).
func end_run(reason: String) -> void:
	if (run_over):
		return
	run_over = true
	$World.set_paused(true)
	$HUD/WordBox.hide()
	var results := $HUD/GameOverUI/Margin/Results
	results.get_node("GameOverText").text = "Sly made it!" if reason == "time_up" else "Game Over!"
	@warning_ignore("integer_division")
	results.get_node("Stats/WPM/WPMLabel").text = "%d" % (words_completed / max((int(time_elapsed) / 60), 1))
	if (total_letters == 0):
		results.get_node("Stats/Accuracy/AccuracyLabel").text = "-"
	else:
		results.get_node("Stats/Accuracy/AccuracyLabel").text = "%.01f%%" % ((float(correct_letters) / float(total_letters)) * 100)
	$HUD/GameOverUI.show()

# Back to the title, which still has the mode and length chosen for this run (GameState keeps them).
func play_again() -> void:
	Router.goto_title()

func add_health():
	if (health < 3):
		health += 1
	if (health == 3):
		$Fox.position.x = 920
	elif (health == 2):
		$Fox.position.x = 500

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (!run_over):
		time_elapsed += delta

	if (velocity.x != 0):
		$Fox.position.x -= 2
		velocity.x += 2

	# Journey counts up. Timed counts down, rounding up so it starts on the full length
	# and reads 00:00 only once time is up.
	var shown_seconds: int
	if (GameState.mode == GameState.Mode.TIMED):
		var time_left: float = max(GameState.timed_length_s - time_elapsed, 0.0)
		shown_seconds = ceili(time_left)
		if (time_left <= 0.0):
			end_run("time_up")
	else:
		shown_seconds = int(time_elapsed)

	@warning_ignore("integer_division")
	var minutes = shown_seconds / 60
	var seconds = shown_seconds % 60

	$HUD/TimerBox/TimerLabel.text = "%02d:%02d" % [minutes, seconds]
