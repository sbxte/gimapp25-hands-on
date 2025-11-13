extends MarginContainer

@onready var label: Label = $MarginContainer/Label
@onready var timer: Timer = $Timer

const MAX_WIDTH = 256

var text = ""
var letter_index = 0


var letter_time = 0.05

func display_text(displayed_text : String):
	text = displayed_text
	label.text = displayed_text
	
	# Wait for the resizing since it'll go off on its own w/o this
	await resized
	custom_minimum_size.x = min(size.x, MAX_WIDTH)
	
	if size.x > MAX_WIDTH:
		label.autowrap_mode = TextServer.AUTOWRAP_WORD
		await resized # wait for x to resize
		await resized # wait for y to resize
		custom_minimum_size.y = size.y
	
	var above = 24 # Pixels above the sprite
	# Centering, setting it above the sprites
	global_position.x -= size.x / 2
	global_position.y -= size.y + above
	
	label.text = ""
	
	_display_letter()
	
func _display_letter():
	label.text += text[letter_index]
	
	letter_index += 1
	if letter_index >= text.length():
		Events.emit_signal("finished_displaying")
		return
	
	match text[letter_index]:
		_:
			timer.start(letter_time)


func _on_timer_timeout() -> void:
	_display_letter()
