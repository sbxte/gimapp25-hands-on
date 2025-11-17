extends Control
@onready var pause_button: Button = $HBoxContainer/PauseButton

func _on_pause_button_pressed() -> void:
	SceneManager.change_scene("res://scenes/pause_menu.tscn")
