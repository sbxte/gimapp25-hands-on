extends Control

@onready var h_slider: HSlider = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/ProgressBar/HSlider
@onready var progress_bar: ProgressBar = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/ProgressBar
@onready var back_button: Button = $PanelContainer/MarginContainer/HBoxContainer/BackButton
@onready var main_background: TextureRect = $MainBackground
@onready var game_background: TextureRect = $GameBackground

var master_bus = AudioServer.get_bus_index("Master")

func _ready() -> void:
	var pause_menu = get_tree().get_first_node_in_group("PauseMenu")
	print(SceneManager.path_history.get(0), SceneManager.overlays.get(0))
	if not SceneManager.path_history.is_empty() or not SceneManager.overlays.is_empty():
		if SceneManager.path_history.get(0) == "res://scenes/menus/main_menu.tscn" && SceneManager.overlays.get(0) != pause_menu: 
			main_background.visible = true
			game_background.visible = false
		elif SceneManager.overlays.get(0) == pause_menu:
			main_background.visible = false
			game_background.visible = true
	progress_bar.value = h_slider.value

func _on_h_slider_value_changed(value: float) -> void:
	progress_bar.value = value
	AudioServer.set_bus_volume_db(master_bus, value)
	
	if value == -30.0:
		AudioServer.set_bus_mute(master_bus, true)
	else:
		AudioServer.set_bus_mute(master_bus, false)

func _on_back_button_pressed() -> void:
	SceneManager.go_back()
