extends Node

@export_subgroup("Grid")
@export var grid_size := Vector2i(4, 4)

@export_subgroup("Difficulty")
@export var timer_duration: float
@export var level := 1
@export var max_pairs := -1
@export var stages := 5
@export var time_bonus := 10
@export var endless_mode := false

@export_subgroup("References")
@export var play_field: PlayField
@export var timer: TimerController

func _ready() -> void:
	play_field.level = level
	play_field.stages = stages
	play_field.max_pairs = max_pairs
	play_field.grid_size = grid_size
	play_field.reset_cats()
	play_field.time_bonus = time_bonus
	play_field.endless_mode = endless_mode
	play_field.game_finished = false

	timer.disable()
