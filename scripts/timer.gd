class_name TimerController
extends Node2D

signal timer_start
signal timer_ended

@export var timer: Timer
@export var sprite: Sprite2D
@export var text: RichTextLabel

var speed := 1.
var lerp_start: float
var ended := false

func _ready() -> void:
	timer.connect("timeout", func(): emit_signal("timer_ended"))

func _process(_delta: float) -> void:
	var rem_time := actual_time()
	if rem_time == 0 and not ended:
		ended = true
		emit_signal("timer_ended")

	text.clear()
	if speed == 1:
		text.push_color(Color.WHITE)
	else:
		text.push_color(Color.RED)
	text.add_text(str(ceil(rem_time)) + "s (PLACEHOLDER)")

# Reset the timer
func reset(speed: float = 1) -> void:
	self.speed = speed
	lerp_start = 30
	timer.start(lerp_start)

# Implement our own timer functionality with speed manipulation
# Linearly interpolate time based on a starting point scaled by speed
# And update starting point every time speed is changed
func actual_time() -> float:
	return maxf(0, speed * (timer.time_left - lerp_start) + lerp_start)

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
