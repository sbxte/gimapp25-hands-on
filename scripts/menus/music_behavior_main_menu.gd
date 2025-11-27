extends Node

func _ready() -> void:
	if not AudioManager.main_menu_music.playing:
		AudioManager.main_menu_music.play()
