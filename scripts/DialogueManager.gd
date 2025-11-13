extends Node

@onready var textbox_scene = preload("res://scenes/speech_bubble.tscn")

var dialogue_lines : Array[String] = []
var current_line_index = 0

var textbox
var textbox_pos: Vector2

var is_dialogue_active = false
var can_advance_line = false

func start_dialogue(pos: Vector2, lines: Array[String]):
	if is_dialogue_active:
		return
	dialogue_lines = lines
	textbox_pos = pos
	show_text_box()
	
	is_dialogue_active = true

func show_text_box():
	textbox = textbox_scene.instantiate()
	if not Events.is_connected("finished_displaying", on_textbox_finished_displaying):
		Events.connect("finished_displaying", on_textbox_finished_displaying)
	get_tree().root.add_child(textbox)
	textbox.global_position = textbox_pos
	textbox.get_node("Textbox").display_text(dialogue_lines[current_line_index])
	can_advance_line = false

func on_textbox_finished_displaying():
	can_advance_line = true

func _unhandled_input(event: InputEvent) -> void:
	if (
		event.is_action_pressed("skip_dialogue") &&
		is_dialogue_active &&
		can_advance_line
	):
		textbox.queue_free()
		
		current_line_index += 1
		if current_line_index >= dialogue_lines.size():
			is_dialogue_active = false
			current_line_index = 0
			return
		
		show_text_box()
