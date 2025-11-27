extends Node

@onready var button: BaseButton = $".."

func _ready() -> void:
	button.pressed.connect(func() :
		AudioManager.stop_all_music()
		get_tree().quit()
	)

