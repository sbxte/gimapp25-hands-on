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

var master_bus = AudioServer.get_bus_index("Master")
var sfx_bus = AudioServer.get_bus_index("SFX")
var music_bus = AudioServer.get_bus_index("Music")

func _ready() -> void:

	master_bar.value = master_slider.value
	sfx_bar.value = sfx_slider.value
	music_bar.value = music_slider.value

func _on_master_slider_value_changed(value: float) -> void:
	master_bar.value = value

	AudioServer.set_bus_volume_linear(master_bus, value)
	AudioServer.set_bus_mute(master_bus, is_zero_approx(value))

func _on_sfx_slider_value_changed(value: float) -> void:
	sfx_bar.value = value

	AudioServer.set_bus_volume_linear(sfx_bus, value)
	AudioServer.set_bus_mute(master_bus, is_zero_approx(value))

func _on_music_slider_value_changed(value: float) -> void:
	music_bar.value = value

	AudioServer.set_bus_volume_linear(music_bus, value)
	AudioServer.set_bus_mute(master_bus, is_zero_approx(value))
