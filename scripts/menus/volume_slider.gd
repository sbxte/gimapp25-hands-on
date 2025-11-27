extends Node

@export var bar: TextureProgressBar
@export var slider: Slider

@export var bus: String
@onready var bus_idx := AudioServer.get_bus_index(bus)

func _ready() -> void:
	bar.value = AudioManager.get_volume_linear(bus)
	(slider as Range).value_changed.connect(on_range_change)

func on_range_change(value: float):
	bar.value = value
	AudioManager.set_volume_linear(bus, value)
