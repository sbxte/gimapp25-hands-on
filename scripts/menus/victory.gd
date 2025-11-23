extends CanvasLayer

@onready var game_background: TextureRect = $Control/GameBackground

func _ready() -> void:
	game_background.visible = true
