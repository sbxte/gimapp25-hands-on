extends Button

@export var pause_menu_path: String

func _pressed() -> void:
	if pause_menu_path:
		SceneManager.overlay_scene(pause_menu_path)

