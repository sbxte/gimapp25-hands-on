extends Node

@export_file("*.tscn") var epilogue_scene: String

func _ready() -> void:
	Events.pre_advance_level.connect(on_pressed)

func on_pressed() -> void:
	Events.cancel_advance_level.emit()
	if not SaveSystem.get_data().has_seen_epilogue:
		SceneManager.change_scene(epilogue_scene, false)

