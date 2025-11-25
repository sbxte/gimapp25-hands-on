extends Node

@onready var button: BaseButton = $".."

func _ready() -> void:
	button.pressed.connect(func() : SceneManager.go_back())
