class_name SetSceneBehavior
extends Node

@export var backtrack := false
@export var track_history: bool = false
@export var restart_scene: bool = false
@export_file_path var scene_path: String

@onready var button: Button = $".."

func _ready() -> void:
	button.pressed.connect(pressed)

func pressed() -> void:
	get_tree().paused = false
	if restart_scene:
		get_tree().reload_current_scene()
		return

	if backtrack:
		SceneManager.go_back()
	else:
		SceneManager.change_scene(scene_path, track_history)
