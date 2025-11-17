extends Node

@export var grid_size := Vector2i(4, 4)
@export var timer_duration: float

@export var stages := 5
@export var time_bonus := 10

@export var play_field: PlayField
@export var timer: TimerController

func _ready() -> void:
	play_field.grid_size = grid_size
	play_field.reset_cats()
	play_field.time_bonus = time_bonus

	timer.start_duration = timer_duration
	timer.reset()
	pass
