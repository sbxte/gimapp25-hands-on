extends Node

var scene_history : Array[String] = []

var overlayed_scene: Node

func change_scene(new_scene_path: String, track: bool = true) -> void:
	if track and get_tree().current_scene:
		var current_scene := get_tree().current_scene.scene_file_path
		scene_history.append(current_scene)
	get_tree().change_scene_to_file(new_scene_path)

func overlay_scene(new_scene_path: String) -> void:
	get_tree().paused = true
	overlayed_scene = load(new_scene_path).instantiate()
	get_tree().current_scene.add_child(overlayed_scene)

func unoverlay_scene() -> void:
	overlayed_scene.get_parent().remove_child(overlayed_scene)
	overlayed_scene.queue_free()
	get_tree().paused = false

func go_back() -> void:
	if not scene_history.is_empty():
		var previous_scene_path = scene_history.pop_back()
		get_tree().change_scene_to_file(previous_scene_path)
