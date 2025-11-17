extends Control
@onready var continue_button: Button = $PanelContainer/MarginContainer/VBoxContainer/Continue/PanelContainer/ContinueButton
@onready var settings_button: Button = $PanelContainer/MarginContainer/VBoxContainer/Settings/PanelContainer2/SettingsButton
@onready var quit_button: Button = $PanelContainer/MarginContainer/VBoxContainer/Quit/PanelContainer3/QuitButton



func _on_continue_button_pressed() -> void:
	SceneManager.change_scene("res://scenes/Main.tscn")


func _on_settings_button_pressed() -> void:
	SceneManager.change_scene("res://scenes/settings.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()
