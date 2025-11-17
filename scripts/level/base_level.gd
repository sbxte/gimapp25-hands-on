extends Node

@export var grid_size := Vector2i(4, 4)

@export var play_field: PlayField

func _ready() -> void:
	play_field.grid_size = grid_size
	play_field.reset_cats()
	pass
