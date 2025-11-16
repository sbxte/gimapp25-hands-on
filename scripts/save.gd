class_name Save
extends Object

# Defaults are set as the values you have when first launching the game
# Aka fresh start

var endless_mode_levels_cleared := 0

func to_json_str() -> String:
	# Godot's JSON module works using Godot's Dictionary Variant
	var data := {
		"endless_mode_levels_cleared": endless_mode_levels_cleared
	}
	return JSON.stringify(data)

static func from_json_str(string: String) -> Save:
	var save := Save.new()

	var json := JSON.new()
	var result := json.parse(string)
	if result == OK and json.data is Dictionary:
		var json_dict := json.data as Dictionary
		save.set_var(json_dict, "endless_mode_levels_cleared")
		return save
	else:
		return null

func set_var(json: Dictionary, var_name: String):
	json[var_name] = get(var_name)
