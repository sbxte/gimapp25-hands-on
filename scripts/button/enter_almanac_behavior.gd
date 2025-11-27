extends Node

@onready var button: TextureButton = $".."

func _ready() -> void:
	var data := SaveSystem.get_data()
	if data.levels_completed >= 5 and data.cats_encountered.all(func(encounter: bool): return encounter == true):
		button.show()
	else:
		button.hide()

