extends Node

@onready var button: Button = $".."

func _ready() -> void:
	button.pressed.connect(func() : get_tree().paused = true)
