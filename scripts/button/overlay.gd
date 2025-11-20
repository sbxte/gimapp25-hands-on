extends Node

@export var overlay_path: String
@onready var button: Button = $".."

func _ready() -> void:
	button.pressed.connect(func() : SceneManager.overlay_scene(overlay_path))
