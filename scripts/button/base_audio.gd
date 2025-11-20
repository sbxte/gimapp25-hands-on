extends Node

@onready var button: Button = $".."

func _ready() -> void:
	button.pressed.connect(func(): AudioManager.click.play())
	button.mouse_entered.connect(func(): AudioManager.hover.play())
