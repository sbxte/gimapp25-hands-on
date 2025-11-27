extends Node

@export_file var scene: String
@onready var button: BaseButton = $".."

func _ready() -> void:
	button.pressed.connect(on_pressed)

func on_pressed() -> void:
	if SceneManager.can_unoverlay():
		SceneManager.unoverlay_scene()
	else:
		SceneManager.change_scene(scene)
