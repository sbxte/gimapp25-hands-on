extends Node

@export var min_level_unlock: int = 1

@export var locked_asset: CompressedTexture2D
@export var unlocked_asset: CompressedTexture2D

@onready var button: TextureButton = $".."

func _ready() -> void:
	if SaveSystem.get_data().levels_completed < min_level_unlock:
		button.texture_normal = locked_asset
	else:
		button.texture_normal = unlocked_asset


