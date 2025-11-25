extends Node

@export_file("*.tscn") var level_paths: Array[String] = ["", "", "", "", ""]
@export_file("*.tscn") var level_menu: String
@onready var button: BaseButton = $".."

var level := 1

func _ready() -> void:
	Events.on_victory.connect(set_next_level)
	button.pressed.connect(func():
		if level < level_paths.size():
			SceneManager.change_scene(level_paths[level], false)
		else:
			SceneManager.change_scene(level_menu, false)
	)

func set_next_level(level: int) -> void:
	self.level = level - 1
