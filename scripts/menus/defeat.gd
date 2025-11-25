extends CanvasLayer

@export var animation_player: AnimationPlayer

func _ready() -> void:
	Events.on_defeat.connect(on_defeat)
	Events.on_defeat_endless_mode.connect(func(_stages_cleared: int): on_defeat())

func on_defeat() -> void:
	animation_player.play("blur")
	await animation_player.animation_finished
	animation_player.play("slide")
