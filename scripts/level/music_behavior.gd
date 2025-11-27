extends Node

func _ready() -> void:
	AudioManager.stop_all_music()
	AudioManager.music.play()
