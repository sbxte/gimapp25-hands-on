extends Node

func _ready() -> void:
	if not AudioManager.almanac_music.playing:
		AudioManager.almanac_music.play()
