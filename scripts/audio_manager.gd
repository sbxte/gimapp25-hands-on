extends Node

@export_subgroup("Button")
@export var click: AudioStreamPlayer
@export var hover: AudioStreamPlayer
@export var pullup: AudioStreamPlayer

@export_subgroup("Ingame")
@export var music: AudioStreamPlayer
@export var almanac_music: AudioStreamPlayer
@export var main_menu_music: AudioStreamPlayer
@export var level_music: AudioStreamPlayer
@export var endless_music: AudioStreamPlayer

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
	almanac_music.stop()
	main_menu_music.stop()
	level_music.stop()
	endless_music.stop()

func _ready() -> void:
	Events.on_victory.connect(on_victory)
	init_volume()

func on_victory(_level: int) -> void:
	AudioManager.stop_all_music()
	AudioManager.trace.stop()
	AudioManager.victory.play()

func on_defeat() -> void:
	AudioManager.stop_all_music()
	AudioManager.trace.stop()

func init_volume() -> void:
	for i in range(AudioServer.bus_count):
		var bus := AudioServer.get_bus_name(i)
		set_volume_linear(bus, get_volume_linear(bus))

func set_volume_linear(bus: String, vol_linear: float) -> void:
	var data := SaveSystem.get_data()
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index(bus), vol_linear)
	match bus:
		"Master":
			data.vol_master = vol_linear
		"SFX":
			data.vol_sfx = vol_linear
		"Music":
			data.vol_music = vol_linear
		_:
			printerr("Invalid bus volume name")
	SaveSystem.write_data()

func get_volume_linear(bus_name: String) -> float:
	var data := SaveSystem.get_data()
	match bus_name:
		"Master":
			return data.vol_master
		"SFX":
			return data.vol_sfx
		"Music":
			return data.vol_music
		_:
			printerr("Invalid bus volume name")
			return -1
