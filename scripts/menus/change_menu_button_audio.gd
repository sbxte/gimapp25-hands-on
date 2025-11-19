extends Node

var button: Button

func _ready() -> void:
	button = get_parent()
	button.pressed.connect(func(): AudioManager.pullup.play())
	button.mouse_entered.connect(func(): AudioManager.hover.play())
