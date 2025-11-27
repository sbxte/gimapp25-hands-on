extends Node

@onready var button: BaseButton = $".."

func _ready() -> void:
	AudioManager.stop_all_music()
	button.pressed.connect(func() : get_tree().quit())

