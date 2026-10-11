extends Node2D

var current_letter: int
var current_word: String
var lines
var font: Font

var total_letters: int
var correct_letters: int
var words_completed: int
var time_elapsed: float

const FONT_SIZE = 24

var grace_timer: Timer
var health: int
# Set by end_run(); after that, typing and the clock stop.
var run_over := false

var velocity: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	seed(int(Time.get_unix_time_from_system()))
	current_letter = 0
	font = load("res://assets/fonts/courierprime.ttf")
	# Load first word
	var file = FileAccess.open("res://data/words/6letters.csv", FileAccess.READ)
	var letter6 = file.get_as_text()
	file.close()
	lines = letter6.split("\n")
	var line = randi() % lines.size()
	current_word = lines[line]
	$CurrentWord.push_font(font)
	$CurrentWord.push_font_size(FONT_SIZE)
	$CurrentWord.add_text(current_word.substr(0, current_letter))
	$CurrentWord.push_underline(Color.GREEN)
	$CurrentWord.add_text(current_word[current_letter])
	$CurrentWord.pop()
	$CurrentWord.add_text(current_word.substr(current_letter + 1, current_word.length()))
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

	$ModeLabel.text = "Mode: " + GameState.mode_label()

func _input(event: InputEvent) -> void:
	if (run_over):
		return
	if (event is InputEventKey and !event.is_echo() and !event.is_released()):
		event = event as InputEventKey
		if (event.as_text_keycode().to_lower() == current_word[current_letter].to_lower()):
			current_letter += 1
			if (current_letter == current_word.length()):
				# Load a new word.
				current_letter = 0
				var line = randi() % lines.size()
				current_word = lines[line]
				words_completed += 1
				add_health()
			
			# Clear word again, and add in green underline.
			$CurrentWord.clear()
			$CurrentWord.push_font(font)
			$CurrentWord.push_font_size(FONT_SIZE)
			$CurrentWord.add_text(current_word.substr(0, current_letter))
			$CurrentWord.push_underline(Color.GREEN)
			$CurrentWord.add_text(current_word[current_letter])
			$CurrentWord.pop()
			$CurrentWord.add_text(current_word.substr(current_letter + 1, current_word.length()))
			correct_letters += 1
		else:
			# Handle health
			if (grace_timer.is_stopped()):
				remove_health()
				grace_timer.start(3)
			
			# Inject a red color before and after the current letter
			$CurrentWord.clear()
			$CurrentWord.push_font(font)
			$CurrentWord.push_font_size(FONT_SIZE)
			$CurrentWord.add_text(current_word.substr(0, current_letter))
			$CurrentWord.push_color(Color.RED)
			$CurrentWord.push_underline(Color.RED)
			$CurrentWord.add_text(current_word[current_letter])
			$CurrentWord.pop()
			$CurrentWord.pop()
			$CurrentWord.add_text(current_word.substr(current_letter + 1, current_word.length()))
		total_letters += 1

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
	$CurrentWord.hide()
	$GameOverUI/GameOverText.text = "Sly made it!" if reason == "time_up" else "Game Over!"
	@warning_ignore("integer_division")
	$GameOverUI/WPMLabel.text = "Words per Minute: %d" % (words_completed / max((int(time_elapsed) / 60), 1))
	if (total_letters == 0):
		$GameOverUI/AccuracyLabel.text = "Accuracy: -"
	else:
		$GameOverUI/AccuracyLabel.text = "Accuracy: %.01f" % ((float(correct_letters) / float(total_letters)) * 100)
	$GameOverUI.show()

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

	$TimerLabel.text = "%02d:%02d" % [minutes, seconds]
