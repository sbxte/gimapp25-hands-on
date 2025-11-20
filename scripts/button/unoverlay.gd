extends Node

@onready var button: Button = $".."

func _ready() -> void:
	button.visible = not SceneManager.overlays.is_empty()
	button.pressed.connect(func() : SceneManager.unoverlay_scene())

