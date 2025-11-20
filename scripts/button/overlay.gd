extends Node

@export_file_path var overlay_path: String
@onready var button: Button = $".."

func _ready() -> void:
	button.pressed.connect(func() : SceneManager.overlay_scene(overlay_path))
