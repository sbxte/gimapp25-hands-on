extends CanvasLayer

const correct_match_lines: Array[String] = [
	"Yes, Good. Brain functioning.",
	"Cat to cat, simple. You did it. Wow.",
	"See? Matching isn’t hard. Even for you.",
	"Good, very good.",
	"Excellent, they will fight with… mild enthusiasm",
	"Excellent Job, Human. I almost believe in you.",
	"A streak, impressive, for a human.",
	"Nice, very nice."
]
const wrong_match_lines: Array[String] = [
	"No. Wrong. Incorrect. Bad.",
	"What—what is THAT? Stop.",
	"Why would you do that?",
	"Is your brain functioning, Human?",
	"Stop guessing. Use brain, please.",
	"Nuh uh, that won’t do.",
	"You just committed a war crime in the whole Felis Dominion!",
	"If you do that again, I’m revoking your thumbs."
]

@export var base_level: BaseLevel

@export var lv_text : Label
@export var stage_text : Label
@export var speech_text: Label

@export var timer: Timer

var is_line_animating = false

var full_line : String = ""
var letter_index = 0
var letter_time = 0.005

func _ready() -> void:
	Events.trigger_speech.connect(trigger_speech)
	timer.timeout.connect(display_next_letter)
	var lvl := base_level.level - 1
	if lvl < 6:
		lv_text.text = str(lvl)
	else:
		lv_text.text = "∞"
	Events.update_stage.connect(func(stage: int): stage_text.text = str(stage))

func trigger_speech(correct_match: bool) -> void:
	if is_line_animating:
		return

	is_line_animating = true
	full_line = ""
	letter_index = 0
	speech_text.text = ""

	if correct_match:
		full_line = pick_rand_no_repeat(correct_match_lines, full_line)
	else:
		full_line  = pick_rand_no_repeat(wrong_match_lines, full_line)

	display_next_letter()

func pick_rand_no_repeat(array: Array[String], prev: String) -> String:
	var copy = array.duplicate()
	copy.erase(prev)
	return copy.pick_random()

func display_next_letter():
	if letter_index >= full_line.length():
		timer.stop()
		is_line_animating = false
		return

	speech_text.text += full_line[letter_index]
	letter_index += 1

	timer.start(letter_time)
