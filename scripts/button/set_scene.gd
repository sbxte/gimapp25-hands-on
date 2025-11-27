class_name SetSceneBehavior
extends Node

@export var backtrack := false
@export var track_history: bool = false
@export var restart_scene: bool = false
@export var keep_music: bool = false
@export_file_path var scene_path: String

@onready var button: BaseButton = $".."

func _ready() -> void:
	button.pressed.connect(pressed)

func pressed() -> void:
	get_tree().paused = false
	Events.pre_set_scene.emit()
	if restart_scene:
		SceneManager.restart_scene()
		return

	if not keep_music:
		AudioManager.stop_all_music()
	if backtrack:
		SceneManager.go_back()
	else:
		SceneManager.change_scene(scene_path, track_history)
