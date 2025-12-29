class_name TimerController
extends Node2D

signal timer_ended

@export var timer: Timer
@export var sprite: Sprite2D

var speed := 1.
@export var start_duration: float = 30
var lerp_start: float
var ended := false

var lowtime_5_played := false
var lowtime_10_played := false

func _ready() -> void:
	reset()

func get_progress_percent() -> float:
	if lerp_start == 0: return 0.0
	return 100.0 - ((actual_time() / start_duration) * 100.0)

func _process(_delta: float) -> void:
	var rem_time := actual_time()
	if rem_time == 0 and not ended:
		ended = true
		emit_signal("timer_ended")
	if ended:
		return
	if rem_time <= 5 and not lowtime_5_played:
		AudioManager.lowtime_5.play()
		lowtime_5_played = true
	elif rem_time <= 10 and not lowtime_10_played:
		AudioManager.lowtime_10.play()
		lowtime_10_played = true

func stop() -> void:
	timer.paused = true

# Reset the timer
func reset(speed: float = 1) -> void:
	self.speed = speed
	lerp_start = start_duration
	timer.start(lerp_start)

# Implement our own timer functionality with speed manipulation
# Linearly interpolate time based on a starting point scaled by speed
# And update starting point every time speed is changed
func actual_time() -> float:
	return maxf(0, speed * (timer.time_left - lerp_start) + lerp_start)

func add_time(time: float):
	lerp_start = actual_time() + time
	timer.start(lerp_start)

func set_speed(speed) -> void:
	lerp_start = actual_time()
	timer.start(lerp_start)
	self.speed = speed

func get_speed() -> float:
	return speed

func reset_speed() -> void:
	lerp_start = actual_time()
	timer.start(lerp_start)
	self.speed = 1

func disable() -> void:
	timer.paused = true
	hide()
