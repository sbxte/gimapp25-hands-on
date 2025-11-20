extends Node

@export var backtrack := false
@export var track_history: bool = false
@export var scene_path: String

@onready var button: Button = $".."

func _ready() -> void:
	button.pressed.connect(pressed)

func pressed() -> void:
	if backtrack:
		SceneManager.go_back()
	else:
		SceneManager.change_scene(scene_path, track_history)
