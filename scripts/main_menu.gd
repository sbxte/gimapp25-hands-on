extends Control
@onready var play_button: Button = $PanelContainer/MarginContainer/VBoxContainer/Play/PanelContainer/PlayButton
@onready var settings_button: Button = $PanelContainer/MarginContainer/VBoxContainer/Settings/PanelContainer2/SettingsButton
@onready var quit_button: Button = $PanelContainer/MarginContainer/VBoxContainer/Quit/PanelContainer3/QuitButton

func _on_play_button_pressed() -> void:
	SceneManager.change_scene("res://scenes/main.tscn")

func _on_settings_button_pressed() -> void:
	SceneManager.change_scene("res://scenes/settings.tscn")

func _on_quit_button_pressed() -> void:
	get_tree().quit()
