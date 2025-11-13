class_name Cat
extends Node2D

@export var type: int = 1

var sprite: Sprite2D

# Placeholder lines
const lines : Array[String] = [
	"I wanna kms",
	"Pls send help",
	"Dan if you're reading this hi",
	"Well I'll be damned"
]

func _ready() -> void:
	sprite = find_child("Sprite2D")

func _process(_delta: float) -> void:
	if type == 1:
		sprite.rotation_degrees = 90
	elif type == 2:
		sprite.rotation_degrees = 180
	elif type == 3:
		sprite.rotation_degrees = 270
	else:
		sprite.rotation_degrees = 0

func _on_static_body_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		var mouse_event: InputEventMouseButton = event
		if mouse_event.pressed and mouse_event.button_index == MOUSE_BUTTON_LEFT:
			Events.emit_signal("cat_mouse_click", self.position, self)
		
		DialogueManager.start_dialogue(global_position, lines)

	elif event is InputEventMouse:
		Events.emit_signal("cat_mouse_enter", self.position, self)
	
