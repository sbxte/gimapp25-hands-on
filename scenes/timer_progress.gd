extends Control
class_name TimerProgress

@onready var timer_bar: ProgressBar = $TimerBar
@onready var timer: TimerController = $".."

func _ready() -> void:
	timer_bar.value = timer.get_progress_percent()

func _process(_delta: float) -> void:
	var percent = timer.get_progress_percent()
	timer_bar.value = percent
