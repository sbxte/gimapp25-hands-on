extends Label

func _ready() -> void:
	text = str(SaveSystem.get_data().endless_mode_stages_cleared)

