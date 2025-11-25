extends Node

var reset_data_keybind: Array[String] = ["8", "2"]
var reset_cats_encountered_keybind: Array[String] = ["8", "0"]

func enabled() -> bool:
	return OS.has_feature("debug")

func _unhandled_key_input(event: InputEvent) -> void:
	if test_keybind(event, reset_data_keybind):
		print("Save Data Reset!")
	if test_keybind(event, reset_cats_encountered_keybind):
		print("Cats Encountered Reset!")

func test_keybind(event: InputEvent, keybind: Array[String]) -> bool:
	if keybind.has(OS.get_keycode_string((event as InputEventKey).keycode)) \
		and keybind.all(func(label: String): return Input.is_key_pressed(OS.find_keycode_from_string(label))):
		SaveSystem.reset_data()
		SaveSystem.write_data()
		return true
	return false
