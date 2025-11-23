extends Node

var reset_data_shortcut := ["8", "2"]

func enabled() -> bool:
	return OS.has_feature("debug")

func _unhandled_key_input(event: InputEvent) -> void:
	if reset_data_shortcut.has(OS.get_keycode_string((event as InputEventKey).keycode)):
		if reset_data_shortcut.all(func(label: String): return Input.is_key_pressed(OS.find_keycode_from_string(label))):
			SaveSystem.reset_data()
			SaveSystem.write_data()
