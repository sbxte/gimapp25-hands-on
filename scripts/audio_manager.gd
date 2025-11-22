extends Node

@export_subgroup("Button")
@export var click: AudioStreamPlayer
@export var hover: AudioStreamPlayer
@export var pullup: AudioStreamPlayer

@export_subgroup("Ingame")
@export var music: AudioStreamPlayer

@export var select: AudioStreamPlayer
@export var deselect: AudioStreamPlayer
@export var rightmatch: AudioStreamPlayer
@export var wrongmatch: AudioStreamPlayer
@export var rare_wrongmatch: AudioStreamPlayer
@export var trace: AudioStreamPlayer
@export var lowtime_5: AudioStreamPlayer
@export var lowtime_10: AudioStreamPlayer
@export var victory: AudioStreamPlayer

@export_subgroup("Dialog")
@export var reusable_player: AudioStreamPlayer

func stop_all_music() -> void:
	music.stop()
