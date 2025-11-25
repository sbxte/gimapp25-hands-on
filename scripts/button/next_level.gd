extends Node

@export var play_field: PlayField
@export_file("*.tscn") var level_paths: Array[String] = ["", "", "", "", ""]
@export_file("*.tscn") var level_menu: String
@onready var button: BaseButton = $".."


func _ready() -> void:
	button.pressed.connect(func():
		var level := play_field.level - 1
		if level < level_paths.size():
			SceneManager.change_scene(level_paths[level], false)
		else:
			SceneManager.change_scene(level_menu, false)
	)
