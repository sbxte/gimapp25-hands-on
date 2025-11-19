class_name Cat
extends Node2D

@export var type: int = 1

@export var sprite: Sprite2D

const lines : Array[String] = [
	"I wanna kms",
	"Pls send help",
	"Dan if you're reading this hi",
	"Well I'll be damned"
]

@export var sprites: Array[CompressedTexture2D]

func set_type(type: int) -> void:
	assert(1 <= type and type <= 8)
	sprite.texture = sprites[type - 1]
	self.type = type
	queue_redraw()

func _on_static_body_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		var mouse_event: InputEventMouseButton = event
		if mouse_event.pressed and mouse_event.button_index == MOUSE_BUTTON_LEFT:
			Events.emit_signal("cat_mouse_click", global_position, self)

		DialogueManager.start_dialogue(global_position, lines.pick_random())

	elif event is InputEventMouse:
		Events.emit_signal("cat_mouse_enter", global_position, self)
