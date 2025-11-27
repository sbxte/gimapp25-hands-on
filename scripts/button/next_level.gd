extends Node

@export_file("*.tscn") var level_paths: Array[String] = ["", "", "", "", ""]
@export_file("*.tscn") var level_menu: String
@onready var button: BaseButton = $".."

var level := 1
var should_advance := true

func _ready() -> void:
	Events.on_victory.connect(set_next_level)
	button.pressed.connect(func():
		Events.pre_advance_level.emit()

		advance_level.call_deferred()
	)

	Events.cancel_advance_level.connect(func(): should_advance = false)

func set_next_level(level: int) -> void:
	# The array has levels 1-5 with zero-indexing
	# While the level received has one-indexing
	# So by default this automatically advances the level
	self.level = level

func advance_level() -> void:
	if not should_advance:
		return

	if level < level_paths.size():
		SceneManager.change_scene(level_paths[level], false)
	else:
		SceneManager.change_scene(level_menu, false)

