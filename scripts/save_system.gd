extends Node

const file_name := "user://gamesave"

static func load_save() -> Save:
	# Save file does not exist yet, return default save file
	if not FileAccess.file_exists("user://savegame.save"):
		return Save.new()

	var save_file := FileAccess.open(file_name, FileAccess.READ)

	var save := Save.from_json_str(save_file.get_as_text())
	if save == null:
		# NOTE: Any change made to the Save class that conflicts with previous json serializations of it
		# will result in a fresh Save returned when this function is called. Be warned.
		return Save.new()
	else:
		return save

static func write_save(save: Save) -> void:
	var file := FileAccess.open(file_name, FileAccess.WRITE)
	file.store_string(save.to_json_str())
	# file.flush() # Not needed, automatically called when closed aka also when it falls out of scope
