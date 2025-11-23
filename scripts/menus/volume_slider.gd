extends Node

@export var bar: TextureProgressBar
@export var slider: Slider

@export var bus: String
@onready var bus_idx := AudioServer.get_bus_index(bus)

func _ready() -> void:
	(slider as Range).value_changed.connect(on_range_change)

func on_range_change(value: float):
	bar.value = value
	AudioServer.set_bus_volume_linear(bus_idx, value)
