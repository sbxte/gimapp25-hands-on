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

@export var sprite_res1: CompressedTexture2D
@export var sprite_res2: CompressedTexture2D

func set_type(type: int) -> void:
	match type:
		1:
			sprite.texture = sprite_res1
			sprite.rotation_degrees = 0
		2:
			sprite.texture = sprite_res1
			sprite.rotation_degrees = 90
		3:
			sprite.texture = sprite_res1
			sprite.rotation_degrees = 180
		4:
			sprite.texture = sprite_res1
			sprite.rotation_degrees = 270
		5:
			sprite.texture = sprite_res2
			sprite.rotation_degrees = 0
		6:
			sprite.texture = sprite_res2
			sprite.rotation_degrees = 90
		7:
			sprite.texture = sprite_res2
			sprite.rotation_degrees = 180
		8:
			sprite.texture = sprite_res2
			sprite.rotation_degrees = 270
		_: pass
	self.type = type
	queue_redraw()

# func set_texture(resource: Texture2D):
# 	sprite.texture = resource

func _on_static_body_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		var mouse_event: InputEventMouseButton = event
		if mouse_event.pressed and mouse_event.button_index == MOUSE_BUTTON_LEFT:
			Events.emit_signal("cat_mouse_click", self.position, self)
		
		DialogueManager.start_dialogue(global_position, lines)

	elif event is InputEventMouse:
		Events.emit_signal("cat_mouse_enter", self.position, self)
	
