extends Node

@export var grid_size := Vector2i(4, 4)
@export var timer_duration: float

@export var play_field: PlayField
@export var timer: TimerController

func _ready() -> void:
	play_field.grid_size = grid_size
	play_field.reset_cats()

	timer.start_duration = timer_duration
	timer.reset()
	pass
