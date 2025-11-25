extends CanvasLayer

@export var animation_player: AnimationPlayer

func _ready() -> void:
	Events.on_victory.connect(on_victory)
	animation_player.play("RESET")

func on_victory(_level: int) -> void:
	animation_player.play("blur")
	await animation_player.animation_finished
	animation_player.play("slide")
