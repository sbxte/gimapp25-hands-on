extends Node

@onready var button: Button = $".."

func _ready() -> void:
	button.pressed.connect(func() : SceneManager.unoverlay_scene())

