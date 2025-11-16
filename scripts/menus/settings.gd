extends Control

@onready var h_slider: HSlider = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/ProgressBar/HSlider
@onready var progress_bar: ProgressBar = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/ProgressBar
var master_bus = AudioServer.get_bus_index("Master")

func _ready() -> void:
	progress_bar.value = h_slider.value

func _on_h_slider_value_changed(value: float) -> void:
	progress_bar.value = value
	AudioServer.set_bus_volume_db(master_bus, value)
	
	if value == -30.0:
		AudioServer.set_bus_mute(master_bus, true)
	else:
		AudioServer.set_bus_mute(master_bus, false)
