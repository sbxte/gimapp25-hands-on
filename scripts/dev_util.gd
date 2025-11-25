extends Node

var reset_data_keybind: Array[String] = ["8", "2"]
var reset_cats_encountered_keybind: Array[String] = ["8", "0"]

func enabled() -> bool:
	return OS.has_feature("debug")

func _unhandled_key_input(event: InputEvent) -> void:
	test_keybind(event, reset_data_keybind, func():
		SaveSystem.reset_data()
		SaveSystem.write_data()
		print("Save Data Reset!")
	)
	test_keybind(event, reset_cats_encountered_keybind, func():
		SaveSystem.get_data().cats_encountered.fill(false)
		SaveSystem.write_data()
		print("Cats Encountered Reset!")
	)

func test_keybind(event: InputEvent, keybind: Array[String], callback: Callable):
	if keybind.has(OS.get_keycode_string((event as InputEventKey).keycode)) \
		and keybind.all(func(label: String): return Input.is_key_pressed(OS.find_keycode_from_string(label))):
		callback.call()
