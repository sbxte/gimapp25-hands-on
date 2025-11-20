class_name CutsceneCharMove
extends CutsceneComponent

@export var character: CharacterResource

@export var sprite: String

@export var position_update: bool = false
@export var position: Vector2

@export var scale_update: bool = false
@export var scale: float = 1.

@export var flip_update: bool = false
@export var flipped_h: bool
@export var flipped_v: bool
