extends Node

var scene_history : Array[String] = []

func change_scene(new_scene_path) -> void:
	if get_tree().current_scene:
		scene_history.append(get_tree().current_scene.scene_file_path)
	get_tree().change_scene_to_file(new_scene_path)
	
func go_back() -> void:
	if not scene_history.is_empty():
		var previous_scene_path = scene_history.pop_back()
		get_tree().change_scene_to_file(previous_scene_path)
