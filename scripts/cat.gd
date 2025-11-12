class_name Cat
extends Node



@export var type: int = 1

var sprite: Sprite2D

func _ready() -> void:
	sprite = find_child("Sprite2D")

func _process(delta: float) -> void:
	if type == 1: 
		sprite.rotation_degrees = 90
	elif type == 2: 
		sprite.rotation_degrees = 180
	elif type == 3: 
		sprite.rotation_degrees = 270
	else:
		sprite.rotation_degrees = 0
