extends Node

@onready var button: BaseButton = $".."

func _ready() -> void:
	button.pressed.connect(func() : get_tree().quit())

