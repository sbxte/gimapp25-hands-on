extends Control

# Master
@onready var master_bar: TextureProgressBar = $PanelContainer/MarginContainer/VBoxContainer/Master/MasterBar/TextMasterBar
@onready var master_slider: HSlider = $PanelContainer/MarginContainer/VBoxContainer/Master/MasterBar/MasterSlider

# SFX
@onready var sfx_bar: TextureProgressBar = $PanelContainer/MarginContainer/VBoxContainer/SFX/SFXBar/TextSFXBar
@onready var sfx_slider: HSlider = $PanelContainer/MarginContainer/VBoxContainer/SFX/SFXBar/SFXSlider

# Music
@onready var music_bar: TextureProgressBar = $PanelContainer/MarginContainer/VBoxContainer/Music/MusicBar/TextMusicBar
@onready var music_slider: HSlider = $PanelContainer/MarginContainer/VBoxContainer/Music/MusicBar/MusicSlider


@onready var back_button: Button = $PanelContainer/MarginContainer/HBoxContainer/BackButton
@onready var main_background: TextureRect = $MainBackground
@onready var game_background: TextureRect = $GameBackground

var master_bus = AudioServer.get_bus_index("Master")
var sfx_bus = AudioServer.get_bus_index("SFX")
var music_bus = AudioServer.get_bus_index("Music")

func _ready() -> void:
	var pause_menu = get_tree().get_first_node_in_group("PauseMenu")
	if not SceneManager.path_history.is_empty() or not SceneManager.overlays.is_empty():
		if SceneManager.path_history.get(0) == "res://scenes/menus/main_menu.tscn" && SceneManager.overlays.get(0) != pause_menu: 
			main_background.visible = true
			game_background.visible = false
		elif SceneManager.overlays.get(0) == pause_menu:
			main_background.visible = false
			game_background.visible = true
	master_bar.value = master_slider.value
	sfx_bar.value = sfx_slider.value
	music_bar.value = music_slider.value

func _on_master_slider_value_changed(value: float) -> void:
	master_bar.value = value
	
	AudioServer.set_bus_volume_db(master_bus, value)
	
	if value <= -30.0:
		AudioServer.set_bus_mute(master_bus, true)
	else:
		AudioServer.set_bus_mute(master_bus, false)


func _on_sfx_slider_value_changed(value: float) -> void:
	sfx_bar.value = value
	
	AudioServer.set_bus_volume_db(sfx_bus, value)
	
	if value <= -30.0:
		AudioServer.set_bus_mute(sfx_bus, true)
	else:
		AudioServer.set_bus_mute(sfx_bus, false)


func _on_music_slider_value_changed(value: float) -> void:
	music_bar.value = value
	
	AudioServer.set_bus_volume_db(music_bus, value)
	
	if value <= -30.0:
		AudioServer.set_bus_mute(music_bus, true)
	else:
		AudioServer.set_bus_mute(music_bus, false)
