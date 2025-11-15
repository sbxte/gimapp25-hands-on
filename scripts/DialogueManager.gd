extends Node

@onready var textbox_scene = preload("res://scenes/speech_bubble.tscn")

var dialogue_line : String = ""
var current_line_index = 0

var textbox
var textbox_pos: Vector2

var is_dialogue_active = false

func start_dialogue(pos: Vector2, lines: String):
	if is_dialogue_active:
		return
	dialogue_line = lines
	textbox_pos = pos
	show_text_box()
	
	if not Events.is_connected("finished_displaying", on_textbox_finished_displaying):
		Events.connect("finished_displaying", on_textbox_finished_displaying)
	
	is_dialogue_active = true

func show_text_box():
	textbox = textbox_scene.instantiate()
	get_tree().root.add_child(textbox)
	textbox.global_position = textbox_pos
	textbox.get_node("Textbox").display_text(dialogue_line)

func on_textbox_finished_displaying():
	await get_tree().create_timer(0.5).timeout
	is_dialogue_active = false
	textbox.queue_free()
