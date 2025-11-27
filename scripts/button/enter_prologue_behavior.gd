extends Node

@export_file("*.tscn") var prologue_scene: String
@onready var button: BaseButton = $".."

func _ready() -> void:
	button.pressed.connect(on_pressed)

func on_pressed() -> void:
	if not SaveSystem.get_data().has_seen_prologue:
		SceneManager.change_scene(prologue_scene, false)
