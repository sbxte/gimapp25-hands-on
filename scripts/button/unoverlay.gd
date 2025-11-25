extends Node

@export var texture: CanvasItem
@onready var button: BaseButton = $".."

func _ready() -> void:
	if texture:
		texture.visible = not SceneManager.overlays.is_empty()
	button.disabled = SceneManager.overlays.is_empty()
	button.pressed.connect(func() : SceneManager.unoverlay_scene())
