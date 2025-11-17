extends Button

@export var backtrack := false
@export var track_history: bool = false
@export var scene_path: String

func _process(_delta: float) -> void:
	pass



func _pressed() -> void:
	if backtrack:
		SceneManager.unoverlay_scene()
	else:
		SceneManager.change_scene(scene_path, track_history)
