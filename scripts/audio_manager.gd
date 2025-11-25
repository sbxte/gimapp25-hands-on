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
@export var next_stage: AudioStreamPlayer

@export var enter_endless_mode: AudioStreamPlayer

@export_subgroup("Dialog")
@export var reusable_player: AudioStreamPlayer

func stop_all_music() -> void:
	music.stop()

func _ready() -> void:
	Events.on_victory.connect(on_victory)

func on_victory(_level: int) -> void:
	AudioManager.music.stop()
	AudioManager.trace.stop()
	AudioManager.victory.play()
